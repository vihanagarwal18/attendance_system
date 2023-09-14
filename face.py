# import cv2
# video=cv2.VideoCapture(0)  ## 0 for internal webcam, 1 for external webcam
# while(True):
#     ret,frame=video.read() #this give 2 value one is boolean value to check whether webcam is okay or not and second is frame
#     cv2.imshow('frame',frame)
#     k=cv2.waitKey(1) 
#     if k==ord('q'):  #ord is used to convert character to integer and as soon we press q it will close camera
#         break
# video.release()
# cv2.destroyAllWindows()

from flask import Flask, request, jsonify
from flask_cors import CORS
import face_recognition
import numpy as np
from PIL import Image, ImageDraw
from IPython.display import display
import cv2
from datetime import datetime
import csv
import os

app=Flask(__name__)
CORS(app)

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

def open_camera_and_register(name):
    #name = input("Enter the name of the new person: ")
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
    now = datetime.now()
    dtString = now.strftime('%d/%b/%Y, %H:%M:%S')
    
    with open('attendance_list.csv', 'r+') as FILE:
        allLines = FILE.readlines()
        updatedLines = []
        found = False
        for line in allLines:
            entry = line.split(',')
            if entry[0] == name:
                found = True
                updatedLines.append(f'{name},{dtString}\n')
            else:
                updatedLines.append(line)
        
        # If the name was not found, add a new entry
        if not found:
            updatedLines.append(f'{name},{dtString}\n')
        
        FILE.seek(0)
        FILE.truncate()
        FILE.writelines(updatedLines)

def delete_person_from_known_faces():
    global known_face_encodings, known_face_names
    name_to_delete = input("Enter the name of the person to delete: ").strip()
    
    if name_to_delete in known_face_names:
        index_to_delete = known_face_names.index(name_to_delete)
        known_face_encodings.pop(index_to_delete)
        known_face_names.pop(index_to_delete)
        print(f"{name_to_delete} has been deleted from known_faces.csv.")
        # Save the updated data to the CSV file
        save_known_faces()
    else:
        print(f"{name_to_delete} not found in known_faces.csv.")
        

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
    

@app.route('/mark-attendance', methods=['POST'])
def mark_attendance():
    try:
        open_camera_and_mark_attendance()
        return jsonify({'message': 'Attendance marked successfully.'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
@app.route('/register-student/<name>', methods=['POST'])
def register_student(name):
    try:
        open_camera_and_register(name)
        print(known_face_names)
        return jsonify({'message': 'Student registered successfully.'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
@app.route('/delete_person', methods=['POST'])
def delete_person():
    try:
        delete_person_from_known_faces()
        return jsonify({'message': 'Person deleted successfully.'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
    