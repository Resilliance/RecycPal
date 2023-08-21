from kivymd.app import MDApp
from kivy.lang import Builder
from kivy.uix.label import Label
from kivy.uix.pagelayout import PageLayout
from kivy.uix.behaviors import ButtonBehavior
from kivymd.uix.boxlayout import MDBoxLayout
from kivymd.uix.gridlayout import MDGridLayout
from kivymd.uix.bottomnavigation import MDBottomNavigationItem
# from kivymd.uix.toolbar import MDTopAppBar
from kivymd.uix.label import MDLabel
from kivymd.uix.button import MDFillRoundFlatButton,MDFloatingActionButton,MDRoundFlatButton
from kivymd.uix.screen import MDScreen
from kivymd.uix.screenmanager import MDScreenManager
from kivymd.uix.transition.transition import MDSlideTransition
from kivy.uix.camera import Camera
from os.path import join
from kivy.utils import platform
from kivy.uix.image import Image
from kivy.uix.scrollview import ScrollView
from kivymd.uix.card import MDCard
from kivy.graphics.texture import Texture
# from kivy_garden.mapview import MapView, MapMarkerPopup
from plyer import gps, utils
import json
import time
import os
import datetime

# Libraries AI
import cv2
import torch
import pandas
import psutil
import numpy as np
from ultralytics import YOLO

class RecycpalClickableLabel(ButtonBehavior, MDLabel):
    """

    TLDR; Make labels clickable; use RecycpalClickableLabel instead of MDLabel in KV

    RecycpalClickableLabel was created because the KivyMD 'MDTopAppBar'
    didn't have functionality to have an icon immediately followed by 
    text. Like a back button that has text saying where it's going back to

    Example:
        Enter a RecycpalHistoryDetailView and look at the back button.
        MDTopAppBar would not allow us to have 'History' immediately
        following the icon
    
    To combat this lack of functionality, we had to create a class that
    inherited from both ButtonBehavior and MDLabel, this giving this class
    in the KV file functionality of both Labels and Buttons. 
    """
    pass

class RecycpalMapView(MDScreen):
    pass

class RecycpalHistoryDetailView(MDScreen):
    directory = None
    
    def set_directory(self,directory):
        self.directory = directory


    def on_enter(self):

        # Load in JSON to access the data
        existing_data = RecycpalApp.get_running_app().load_image_paths()
        
        # Get Directory Index
        dir_index = RecycpalApp.get_running_app().captured_images.index(self.directory)


        detail_box = self.ids.detail_box
        card = MDCard(size_hint=(0.9,0.9),
                      md_bg_color=(0.894,0.890,0.667,1),
                      pos_hint={'center_x':0.5,'center_y':0.5})
        
        card_box = MDBoxLayout(orientation='vertical',
                               md_bg_color=(0.894,0.890,0.667,1),
                               radius=[15,],
                               padding="10dp")

        card_image = Image(source=self.directory,
                           allow_stretch=True,
                           size_hint=(0.9,0.9),
                           pos_hint={'center_x':0.5,'center_y':0.5})
        
        # Pull Existing Data into MDLabels
        card_name = MDLabel(text=f"Name: {existing_data['name'][f'{dir_index}']}",size_hint_y=None, height="40dp",font_style="H5")
        card_date = MDLabel(text=f"Date Taken: {existing_data['datetime'][f'{dir_index}']}",size_hint_y=None, height="40dp",font_style="H5")
        card_objects_detected = MDLabel(text=f"Objects Detected: {', '.join(set(existing_data['objects_detected'][f'{dir_index}']))}",size_hint_y=None, height="40dp",font_style="H5")
        
        # Add widgets into the card_box 
        card_box.add_widget(card_image)
        card_box.add_widget(card_name)
        card_box.add_widget(card_date)
        card_box.add_widget(card_objects_detected)

        # Add card_box into card widget
        card.add_widget(card_box)

        # Add card into the detail_box (MDBoxLayout)
        detail_box.add_widget(card)

class RecycpalHistory(MDScreen):
    def on_enter(self):
        print(f"entering History")
        captured_images = RecycpalApp.get_running_app().captured_images
        print(f"\n\n{self.ids}\n\n")
        images_box = self.ids.images_box
        images_box.bind(minimum_height=images_box.setter('height'))
        images_box.clear_widgets()
        total_height = 0
        for image in reversed(captured_images):
            card = MDCard(size_hint=(1,None),
                          md_bg_color=(0.894,0.890,0.667,1),
                          on_release=lambda x, image=image: RecycpalApp.get_running_app().open_card(image))
            card_image = Image(source=image,keep_ratio=True,allow_stretch=True)
            card.add_widget(card_image)
            images_box.add_widget(card)
            total_height += card.height
        images_box.height = total_height


            

class RecycpalCamera(MDScreen):
    def __init__(self, **kwargs):
        super(RecycpalCamera, self).__init__(**kwargs)
        self.widgets = {}
        self.image_name = ""
        # self.detections = None

    # def on_enter(self):
    #     super().on_enter()
        # self.ids.camera.index = 1


    def capture(self):
        camera = self.ids['camera']
        time_start = time.strftime("%Y%m%d_%H%M%S")
        if platform == 'android':
            # On Android, the app user data directory is automatically created and accessible without any permissions
            directory = join(MDApp.get_running_app().user_data_dir, "IMG_{}.png".format(time_start))
        elif platform == 'ios':
            # On iOS, you have to use App.user_data_dir as it's part of the app sandbox
            directory = join(MDApp.get_running_app().user_data_dir, "IMG_{}.png".format(time_start))
        else:
            # On desktop platforms, you could use the current directory or any directory you have permissions for
            directory = "data/images/IMG_{}.png".format(time_start)
        
        self.image_name = "IMG_{}.png".format(time_start)
        camera.export_to_png(directory)
        image = cv2.imread(directory)
        results = RecycpalApp.model(directory)
        print(f"\n\n{results}\n\n")
        detections = json.loads(results[0].tojson())
        if detections:
            height, width, _ = image.shape
            final_mask = np.zeros((height,width, 3), dtype=np.uint8)
            colors = [(np.random.randint(0, 255), np.random.randint(0, 255), np.random.randint(0, 255)) for _ in range(len(detections))]
            for detection, color in zip(detections, colors):
                print(detection)
                segments = detection.get('segments')
                x = [int(num) for num in segments['x']]
                y = [int(num) for num in segments['y']]


                # Combine the coords
                points = np.array([[xi,yi] for xi, yi in zip(x,y)])

                # Create Mask Outline
                mask = np.zeros((height, width, 3), dtype=np.uint8)

                # Fill the Mask
                cv2.fillPoly(mask, [points], color=color)

                # Add current mask to final mask
                final_mask += mask

            # Convert image to RGB
            image_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

            # Blend the masked image and the original image
            alpha = 0.4
            blended_image = cv2.addWeighted(image_rgb, alpha, final_mask, 1 - alpha, 0)

            # Draw text on the blended image
            for detection, color in zip(detections, colors):
                segments = detection.get('segments')
                x = [int(num) for num in segments['x']]
                y = [int(num) for num in segments['y']]
                text = detection['name']
                cv2.putText(blended_image, text, (x[0],y[0] - 10), cv2.FONT_HERSHEY_SIMPLEX, 1, color, 2)

            # Overwrite vanilla image
            cv2.imwrite(directory,cv2.cvtColor(blended_image,cv2.COLOR_RGB2BGR))
                
            image = Image(source=directory)
        else:
            image = Image(source=directory)
        
        save_button = MDFillRoundFlatButton(
                        text="Save",
                        md_bg_color=(0.396,0.627,0.537,1),
                        text_color=(1,1,1,1),
                        size_hint=(0.3, 0.05),
                        pos_hint={'center_x': 0.3,'center_y': 0.15},
                        on_release=lambda x: self.save_image(directory,detections),
                    )

        discard_button = MDFillRoundFlatButton(
                            text="Discard",
                            md_bg_color=(0.713,0.153,0.153,1),
                            text_color=(1,1,1,1),
                            size_hint=(0.3,0.05),
                            pos_hint={'center_x':0.7,'center_y':0.15},
                            on_release=lambda x: self.discard_image(directory),
                        )
        # Add Widgets for reference later
        self.widgets['save_button'] = save_button
        self.widgets['discard_button'] = discard_button
        self.widgets['image'] = image

        # Remove the Camera and Capture button widgets
        self.ids['camera_box'].remove_widget(camera)
        self.ids['camera_screen'].remove_widget(self.ids['capture_button'])

        # Show Image and Save/Discard buttons
        self.ids['camera_box'].add_widget(image)
        self.ids['camera_screen'].add_widget(save_button)
        self.ids['camera_screen'].add_widget(discard_button)
        
    def save_image(self, directory,detections):
        print('save\n',directory)
        # Add image directory to the captured_images array
        RecycpalApp.get_running_app().captured_images.append(directory)

        # Get Directory Index
        dir_index = RecycpalApp.get_running_app().captured_images.index(directory)

        # Load existing data
        existing_data = RecycpalApp.get_running_app().load_image_paths()

        # Update directory data
        existing_data['directory'] = RecycpalApp.get_running_app().captured_images
        existing_data['name'][f"{dir_index}"] = self.image_name
        existing_data['datetime'][f"{dir_index}"] = datetime.datetime.now().strftime('%Y-%m-%d')
        existing_data['objects_detected'][f"{dir_index}"] = [detection['name'] for detection in detections]

        with open('image_paths.json','w') as file:
            json.dump(existing_data,file)

        # Remove Image and Save/Discard widgets
        self.ids['camera_box'].remove_widget(self.widgets['image'])
        self.ids['camera_screen'].remove_widget(self.widgets['save_button'])
        self.ids['camera_screen'].remove_widget(self.widgets['discard_button'])

        # Add the Camera and Capture widets
        self.ids['camera_box'].add_widget(self.ids['camera'])
        self.ids['camera_screen'].add_widget(self.ids['capture_button'])

        # Update RecycpalHistory
        RecycpalApp.get_running_app().history.on_enter()

    def discard_image(self, directory):
        print('discard\n',directory)
        try:
            os.remove(directory)
        except:
            print(f"Error: {directory} : {e.strerror}")

        # Remove Image and Save/Discard widgets
        self.ids['camera_box'].remove_widget(self.widgets['image'])
        self.ids['camera_screen'].remove_widget(self.widgets['save_button'])
        self.ids['camera_screen'].remove_widget(self.widgets['discard_button'])

        # Add the Camera and Capture widets
        self.ids['camera_box'].add_widget(self.ids['camera'])
        self.ids['camera_screen'].add_widget(self.ids['capture_button'])

class RecycpalInfoDetailView(MDScreen):
    material = None

    def set_material(self, material):
        self.material = material

    def on_enter(self):
        # Load in JSON to access the data
        existing_data = RecycpalApp.get_running_app().load_static_data()
        
        # Get Use the Material to pull the correct information
        material_info = existing_data[f"{self.material}"]


        material_box = self.ids.material_box
        card = MDCard(size_hint=(0.9,0.9),
                        md_bg_color=(0.894,0.890,0.667,1),
                        pos_hint={'center_x':0.5,'center_y':0.5})
        
        card_box = MDBoxLayout(orientation='vertical',
                                md_bg_color=(0.894,0.890,0.667,1),
                                radius=[15,],
                                padding="10dp")
        card_box_header = MDBoxLayout(orientation='horizontal',
                                      md_bg_color=(0.894,0.890,0.667,1),
                                      size_hint= (1,0.2))
        card_box_header_name = MDLabel(text=f"{self.material}",
                                       font_style="H3",
                                       text_color=(1,1,1,1),
                                       pos_hint={'center_x': 0.7,'center_y': 0.5})

        card_box_header_image = Image(source=f"staticfiles/images/{self.material.lower()}.png",
                                      allow_stretch=True,
                                      size_hint=(0.7,0.7),
                                      pos_hint={'center_x':0.6,'center_y':0.5})

        card_box_body = MDGridLayout(cols=1,
                            padding="10dp",
                            size_hint_y=1.5,
                            md_bg_color=(0.894,0.890,0.667,1))

        # Pull Existing Data into MDLabels
        card_info = MDLabel(text=f"{material_info}",
                            size_hint_y=None,
                            height="40dp",
                            font_style="H5")
        
        # Add widgets into the card_box_header 
        card_box_header.add_widget(card_box_header_image)
        card_box_header.add_widget(card_box_header_name)
        card_box.add_widget(card_box_header)

        # Add info widget to card_box_body
        card_box_body.add_widget(card_info)
        card_box.add_widget(card_box_body)

        # Add card_box into card widget
        card.add_widget(card_box)

        # Add card into the detail_box (MDBoxLayout)
        material_box.add_widget(card)


class RecycpalInfo(MDScreen):
    """
    NOTE: Reminder to eventually make the Cards in the info screen
    dynamically populate instead of statically
    """
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.is_intialized = False

    def on_enter(self):
        
        if self.is_intialized == False:
            # Get Static Data
            existing_data = RecycpalApp.get_running_app().load_static_data()

            # Create Card for each Material
            for key in existing_data:
                card = MDCard(size_hint=(1,None),
                            md_bg_color=(0.894,0.890,0.667,1),
                            on_release=lambda x, key=key: RecycpalApp.get_running_app().open_info_card(key))
                card_box = MDBoxLayout(orientation='horizontal')
                card_image = Image(source=f"staticfiles/images/{key.lower()}.png",
                                size_hint=(0.4,0.85),
                                pos_hint={'center_x':0.5,'center_y':0.5})
                card_label = MDLabel(markup=True,
                                    text=f"{key}",
                                    size_hint=(0.8,1),
                                    pos_hint= {'center_x':0.6},
                                    text_color= (0,0,0,1),
                                    font_style="H3")
                
                card_box.add_widget(card_image)
                card_box.add_widget(card_label)
                card.add_widget(card_box)
                self.ids.info_box.add_widget(card)

                self.is_intialized = True
        else:
            pass


class RecycpalApp(MDApp):       
    model = YOLO('yolov8n-seg.pt')

    # Call previous images taken
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.captured_images = self.load_image_paths()['directory']

    def build(self):
        self.theme_cls.material_style = "M3"
        self.theme_cls.theme_style = "Dark"

        # Request Android Permissions
        self.request_android_permissions()

        # Defining the Screens
        self.history = RecycpalHistory(name="History")
        self.camera = RecycpalCamera(name="Camera")
        self.info = RecycpalInfo(name="Info")
        # self.maps = RecycpalMapView(name="Maps")
        self.card_detail = RecycpalHistoryDetailView(name="Detail")
        self.info_detail = RecycpalInfoDetailView(name="Material")

        self.root.ids.history.add_widget(self.history)
        self.root.ids.history.add_widget(self.card_detail)
        self.root.ids.camera.add_widget(self.camera)
        # self.root.ids.info.add_widget(self.maps)
        self.root.ids.info.add_widget(self.info)
        self.root.ids.info.add_widget(self.info_detail)

    def request_android_permissions(self):
        if platform == 'android':
            # Request permissions for Android
            from android.permissions import request_permissions, Permission
            request_permissions([Permission.ACCESS_FINE_LOCATION])

    
    def load_image_paths(self):
        try:
            with open('image_paths.json','r') as file:
                return json.load(file)
        except FileNotFoundError:
            return {"directory": []}
        
    def load_static_data(self):
        try:
            with open('static_data.json','r') as file:
                return json.load(file)
        except FileNotFoundError:
            return {"directory": []}
        
    def open_card(self,directory):
        print("\n\n",directory)
        self.root.ids.history.get_screen('Detail').set_directory(directory)
        self.root.ids.history.get_screen('History').ids['history_screen'].scroll_y = 1
        self.root.ids.history.transition = MDSlideTransition(direction="left")
        self.root.ids.history.current = "Detail"
        
    def back_to_history(self):
        self.root.ids.history.get_screen('Detail').ids['detail_box'].clear_widgets()
        self.root.ids.history.get_screen('Detail').ids['detail_screen'].scroll_y = 1
        self.root.ids.history.transition = MDSlideTransition(direction="right")
        # self.root.ids.history.get_screen('History').on_enter()
        self.root.ids.history.current = "History"

    def back_to_info(self):
        self.root.ids.info.get_screen('Material').ids['material_box'].clear_widgets()
        self.root.ids.info.get_screen('Material').ids['material_scroll'].scroll_y = 1
        self.root.ids.info.transition = MDSlideTransition(direction="right")
        self.root.ids.info.current = "Info"
        # pass

    def open_info_card(self,material):
        print("\n\n",material)
        self.root.ids.info.get_screen("Material").set_material(material)
        # self.root.ids.info.get_screen("Info").ids['info_box'].clear_widgets()
        self.root.ids.info.transition = MDSlideTransition(direction="left")
        self.root.ids.info.current = "Material"


RecycpalApp().run()
