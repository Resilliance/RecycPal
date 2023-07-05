from kivymd.app import MDApp
from kivy.lang import Builder
from kivy.uix.label import Label
from kivy.uix.pagelayout import PageLayout
from kivy.uix.behaviors import ButtonBehavior
from kivymd.uix.boxlayout import MDBoxLayout
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
import json
import time
import os

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

class RecycpalHistoryDetailView(MDScreen):
    directory = None
    
    def set_directory(self,directory):
        self.directory = directory


    def on_enter(self):
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
        
        card_name = MDLabel(text=f"Name: ",size_hint_y=None, height="40dp",font_style="H5")
        card_date = MDLabel(text=f"Date Taken: ",size_hint_y=None, height="40dp",font_style="H5")
        card_objects_detected = MDLabel(text=f"Objects Detected: ",size_hint_y=None, height="40dp",font_style="H5")
        card_box.add_widget(card_image)
        card_box.add_widget(card_name)
        card_box.add_widget(card_date)
        card_box.add_widget(card_objects_detected)
        card.add_widget(card_box)
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
                        on_release=lambda x: self.save_image(directory),
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
        
    def save_image(self, directory):
        print('save\n',directory)
        # Add image directory to the captured_images array
        RecycpalApp.get_running_app().captured_images.append(directory)
        # Load existing data
        existing_data = RecycpalApp.get_running_app().load_image_paths()

        # Update directory data
        existing_data['directory'] = RecycpalApp.get_running_app().captured_images

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

class RecycpalInfo(MDScreen):
    """
    NOTE: Reminder to eventually make the Cards in the info screen
    dynamically populate instead of statically
    """
    pass

class RecycpalApp(MDApp):       
    # model = YOLO('yolov8n.pt')
    model = YOLO('yolov8n-seg.pt')
    # Call previous images taken
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.captured_images = self.load_image_paths()['directory']

    def build(self):
        self.theme_cls.material_style = "M3"
        self.theme_cls.theme_style = "Dark"

        # Defining the Screens
        self.history = RecycpalHistory(name="History")
        self.camera = RecycpalCamera(name="Camera")
        self.info = RecycpalInfo(name="Info")
        self.card_detail = RecycpalHistoryDetailView(name="Detail")

        self.root.ids.history.add_widget(self.history)
        self.root.ids.history.add_widget(self.card_detail)
        self.root.ids.camera.add_widget(self.camera)
        self.root.ids.info.add_widget(self.info)

    
    def load_image_paths(self):
        try:
            with open('image_paths.json','r') as file:
                return json.load(file)
        except FileNotFoundError:
            return {"directory": []}
    def open_card(self,directory):
        print("\n\n",directory)
        self.root.ids.history.get_screen('Detail').set_directory(directory)
        self.root.ids.history.transition = MDSlideTransition(direction="left")
        self.root.ids.history.current = "Detail"
        
    def back_to_history(self):
        self.root.ids.history.get_screen('Detail').ids['detail_box'].clear_widgets()
        self.root.ids.history.get_screen('Detail').ids['detail_screen'].scroll_y = 1
        self.root.ids.history.transition = MDSlideTransition(direction="right")
        self.root.ids.history.get_screen('History').on_enter()
        self.root.ids.history.current = "History"

    def back_to_info(self):
        # self.root.ids.info.get_screen('Paper')
        pass


RecycpalApp().run()
