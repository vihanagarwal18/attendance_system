# # # import cv2
# # # video=cv2.VideoCapture(0)  ## 0 for internal webcam, 1 for external webcam

# # # while(True):
# # #     ret,frame=video.read() #this give 2 value one is boolean value to check whether webcam is okay or not and second is frame
# # #     cv2.imshow('frame',frame)
# # #     k=cv2.waitKey(1) 
# # #     if k==ord('q'):  #ord is used to convert character to integer and as soon we press q it will close camera
# # #         break
# # # video.release()
# # # cv2.destroyAllWindows()

import face_recognition
import numpy as np
from PIL import Image, ImageDraw
from IPython.display import display
#from google.colab.patches import cv2_imshow
import cv2
from datetime import datetime
import csv
import os

known_face_encodings = []
known_face_names = []


face_1 = face_recognition.load_image_file("training_images/elon.jpg")
face_1_encoding = face_recognition.face_encodings(face_1)[0]

face_2 = face_recognition.load_image_file("training_images/donald_trump.jpg")
face_2_encoding = face_recognition.face_encodings(face_2)[0]

face_3 = face_recognition.load_image_file("training_images/jeffbezos.jpeg")
face_3_encoding = face_recognition.face_encodings(face_3)[0]

known_face_encodings.append(face_1_encoding)
known_face_names.append("Elon Musk")
known_face_encodings.append(face_2_encoding)
known_face_names.append("Donald Trump")
known_face_encodings.append(face_3_encoding)
known_face_names.append("Jeff Bezos")


def load_known_faces():
    global known_face_encodings, known_face_names
    try:
        with open('known_faces.csv', 'r') as file:
            csv_reader = csv.reader(file)
            for row in csv_reader:
                name, encoding_str = row
                encoding = np.fromstring(encoding_str[1:-1], sep=', ')
                known_face_names.append(name)
                known_face_encodings.append(encoding)
    except FileNotFoundError:
        known_face_encodings = []
        known_face_names = []

def save_known_faces():
    with open('known_faces.csv', 'w', newline='') as file:
        csv_writer = csv.writer(file)
        for name, encoding in zip(known_face_names, known_face_encodings):
            encoding_str = np.array2string(encoding, separator=', ')
            csv_writer.writerow([name, encoding_str])

def open_camera_and_register():
    name = input("Enter the name of the new person: ")
    video = cv2.VideoCapture(0)
    while True:
        ret, frame = video.read()
        cv2.imshow('frame', frame)
        k = cv2.waitKey(1)
        if k == ord('q'):
            break
    video.release()
    cv2.destroyAllWindows()
    image_file = f"{name}.jpg"
    cv2.imwrite(image_file, frame)
    register_new_person(image_file, name)

def register_new_person(image_file, name):
    global known_face_encodings, known_face_names
    new_face = face_recognition.load_image_file(image_file)
    new_face_encodings = face_recognition.face_encodings(new_face)
    if len(new_face_encodings) == 0:
        print("No face found in the provided image.")
        return
    # Check if the person is already registered
    for encoding in new_face_encodings:
        match = False
        for known_encoding in known_face_encodings:
            if face_recognition.compare_faces([known_encoding], encoding)[0]:
                match = True
                break
        if not match:
            known_face_encodings.append(encoding)
            known_face_names.append(name)
            print(f"Registered {name}.")
            return
    print(f"{name} is already registered.")

def makeAttendanceEntry(name):
    with open('attendance_list.csv', 'r+') as FILE:
        allLines = FILE.readlines()
        attendanceList = []
        for line in allLines:
            entry = line.split(',')
            attendanceList.append(entry[0])
        if name not in attendanceList:
            now = datetime.now()
            dtString = now.strftime('%d/%b/%Y, %H:%M:%S')
            FILE.writelines(f'\n{name},{dtString}')

def open_camera_and_mark_attendance():
    video = cv2.VideoCapture(0)
    while True:
        ret, frame = video.read()
        face_locations = face_recognition.face_locations(frame)
        face_encodings = face_recognition.face_encodings(frame, face_locations)
        for face_encoding in face_encodings:
            matches = face_recognition.compare_faces(known_face_encodings, face_encoding)
            name = "Unknown"
            if True in matches:
                first_match_index = matches.index(True)
                name = known_face_names[first_match_index]
                makeAttendanceEntry(name)
            top, right, bottom, left = face_locations[0]
            cv2.rectangle(frame, (left, top), (right, bottom), (0, 255, 0), 3)
            cv2.putText(frame, name, (left, top - 20), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2, cv2.LINE_AA)
        cv2.imshow('frame', frame)
        k = cv2.waitKey(1)
        if k == ord('q'):
            break
    video.release()
    cv2.destroyAllWindows()
    
load_known_faces()
#open_camera_and_register()
open_camera_and_mark_attendance()
save_known_faces()
           
# file_name = "testing_images/unknown_el.jpg"
# unknown_image = face_recognition.load_image_file(file_name)
# unknown_image_to_draw = cv2.imread(file_name)
# face_locations = face_recognition.face_locations(unknown_image)
# face_encodings = face_recognition.face_encodings(unknown_image, face_locations)
# pil_image = Image.fromarray(unknown_image)
# draw = ImageDraw.Draw(pil_image)
# for (top, right, bottom, left), face_encoding in zip(face_locations, face_encodings):
#     # See if the face is a match for the known face(s)
#     matches = face_recognition.compare_faces(known_face_encodings, face_encoding)
#     name = "Unknown"
#     face_distances = face_recognition.face_distance(known_face_encodings, face_encoding)
#     best_match_index = np.argmin(face_distances)
#     if matches[best_match_index]:
#         name = known_face_names[best_match_index]
#     # Draw a box around the face using the Pillow module
#     cv2.rectangle(unknown_image_to_draw,(left, top), (right, bottom), (0,255,0),3 )
#     draw.rectangle(((left, top), (right, bottom)), outline=(0, 255, 255))
#     cv2.putText(unknown_image_to_draw,name,(left,top-20), cv2.FONT_HERSHEY_SIMPLEX,1, (0,0,255), 2,cv2.LINE_AA)
#     print(name)
#     makeAttendanceEntry(name)

# # display(pil_image)
# cv2.imshow(unknown_image_to_draw)