#!/usr/bin/env python
# -*-coding=utf-8 -*-

# from PIL import Image
from datetime import datetime
# from io import BytesIO
# import cv2
# import requests
import sys
import base64
import os.path
import face_recognition
import math

fileCheck = sys.argv[1] #ไฟล์ที่รับเข้ามา
fileDB = sys.argv[2] #ไฟล์จาก database ที่รับเข้ามา

save_path = 'C:/xampp/htdocs/backend_laravel/public/' #ตำแหน่งไฟล์ที่บันทึก
send_to_check_fileName = save_path + fileCheck #ชื่อไฟล์เป็นชื่อ-นามสกุล และวันและเวลาที่เข้าทำการตรวจสอบ
database_fileName = save_path + fileDB


def face_distance_to_conf(face_distance, face_match_threshold=0.6):
  if face_distance > face_match_threshold:
    range = (1.0 - face_match_threshold)
    linear_val = (1.0 - face_distance) / (range * 2.0)
    return linear_val * 100
  else:
    range = face_match_threshold
    linear_val = 1.0 - (face_distance / (range * 2.0))
    return (linear_val + ((1.0 - linear_val) * math.pow((linear_val - 0.5) * 2, 0.2))) * 100

database_Pic = face_recognition.load_image_file(database_fileName) # โหลดรูปจาก database
face_encoding = face_recognition.face_encodings(database_Pic) # เข้ารหัสหน้าตา
send_to_check_Pic = face_recognition.load_image_file(send_to_check_fileName) # ไฟล์ที่ต้องการตรวจสอบ
send_to_check_face_encoding = face_recognition.face_encodings(send_to_check_Pic) # เข้ารหัสหน้าตา

if len(face_encoding) and len(send_to_check_face_encoding) > 0:
  face_biden_encoding = face_encoding[0]
  send_to_check_face_biden_encoding = send_to_check_face_encoding[0]

  results = face_recognition.compare_faces([face_biden_encoding], send_to_check_face_biden_encoding)
  face_distances = face_recognition.face_distance(face_biden_encoding, send_to_check_face_encoding)
  percentage = face_distance_to_conf(face_distances)[0]
  print(f'{percentage:.2f}' + '%')
  quit()
else:
  print("No face found in your picture!")
  quit()