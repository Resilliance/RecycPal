from kivymd.app import MDApp
from kivy.lang import Builder
from kivy.uix.label import Label
from kivymd.uix.label import MDLabel
from kivymd.uix.button import MDFillRoundFlatButton
from kivymd.uix.screen import MDScreen
from kivymd.uix.screenmanager import MDScreenManager
from kivy.uix.camera import Camera
from os.path import join
from kivy.utils import platform
from kivy.uix.image import Image
from kivy.uix.scrollview import ScrollView
from kivymd.uix.card import MDCard
import json
import time

# Libraries AI
import cv2
import torch

class RecycpalHistory(MDScreen):
    def on_enter(self):
        captured_images = RecycpalApp.get_running_app().captured_images
        images_box = self.ids.images_box
        images_box.bind(minimum_height=images_box.setter('height'))
        images_box.clear_widgets()
        total_height = 0
        for image in captured_images:
            # card = MDCard(size_hint= (1,None),height=400)
            card = MDCard(size=("200dp","100dp"))
            card_image = Image(source=image,keep_ratio=True,allow_stretch=True)
            card.add_widget(card_image)
            images_box.add_widget(card)
            total_height += card.height
        images_box.height = total_height
            

class RecycpalCamera(MDScreen):
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
            directory = "IMG_{}.png".format(time_start)
        camera.export_to_png(directory)
        MDApp.get_running_app().captured_images.append(directory)
        print("Capt")

    def run_inference(self,dt):
        pass

class RecycpalInfo(MDScreen):
    pass

class RecycpalApp(MDApp):       
    # Call previous images taken
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.captured_images = self.load_image_paths()

    def build(self):
        self.root = Builder.load_file('recycpal.kv')

        self.theme_cls.material_style = "M3"
        self.theme_cls.theme_style = "Dark"

        # Defining the Screens
        self.root.ids.history.add_widget(RecycpalHistory(name="History"))
        self.root.ids.camera.add_widget(RecycpalCamera(name="Camera"))
        self.root.ids.info.add_widget(RecycpalInfo(name="Info"))
    
    def load_image_paths(self):
        try:
            with open('image_paths.json','r') as file:
                return json.load(file)
        except FileNotFoundError:
            return []

    def on_stop(self):
        self.save_image_paths()
        
    def save_image_paths(self):
        with open('image_paths.json','w') as file:
            json.dump(self.captured_images,file)


        return self.root


RecycpalApp().run()
