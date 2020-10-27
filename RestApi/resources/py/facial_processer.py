#!/usr/bin/env python
# -*-coding=utf-8 -*-

from PIL import Image
from datetime import datetime
# from io import BytesIO
# import cv2
import requests
import sys
import base64
import os.path
import face_recognition

arg1 = sys.argv[1] #ชื่อที่รับเข้ามา
arg2 = sys.argv[2] #นามสกุลที่รับเข้ามา

payload = {'name': arg1, 'surname': arg2} #ส่งข้อมูลเพื่อตรวจสอบจาก database ที่มีอยู่
send_to_check_response = requests.get("http://localhost:8000/api/getpicture", params=payload) #ดึง response จาก rest api เพื่อนำมาตรวจสอบ

send_to_check_save_path = 'C:/xampp/htdocs/RestApi/public/image/checkimg/' #ตำแหน่งไฟล์ที่บันทึก
send_to_check_now = datetime.now()
send_to_check_current_time = send_to_check_now.strftime("%d-%m-%Y(%H-%M-%S)")
send_to_check_fileName = arg1+"_"+arg2+"_"+send_to_check_current_time #ชื่อไฟล์เป็นชื่อ-นามสกุล และวันและเวลาที่เข้าทำการตรวจสอบ

send_to_check_completeName = os.path.join(send_to_check_save_path, send_to_check_fileName +".jpg")
send_to_check_fh = open(send_to_check_completeName, "wb")
send_to_check_fh.write(base64.b64decode(send_to_check_response.text))
send_to_check_fh.close()

send_to_check_img = Image.open(send_to_check_save_path + send_to_check_fileName+".jpg")
send_to_check_img.show() #แสดงผลรูป(เช็คคร่าวๆว่ารูปบันทึกได้ไหม)

#
#
#
#

database_response = requests.get("http://localhost:8000/api/getdatabasepicture", params=payload) 

database_save_path = 'C:/xampp/htdocs/RestApi/public/image/querry_fromDB/'
database_now = datetime.now()
database_current_time = database_now.strftime("%d-%m-%Y(%H-%M-%S)")
database_fileName = arg1+"_"+arg2+"_" + database_current_time 

database_completeName = os.path.join(database_save_path, database_fileName +".jpg")
database_fh = open(database_completeName, "wb")
database_fh.write(base64.b64decode(database_response.text))
database_fh.close()

database_img = Image.open(database_save_path + database_fileName+".jpg")
database_img.show()

database_Pic = face_recognition.load_image_file(database_save_path + database_fileName+".jpg") # โหลดรูปโอบาม่า
face_encoding = face_recognition.face_encodings(database_Pic)[0] # เข้ารหัสหน้าตา
send_to_check_Pic = face_recognition.load_image_file(send_to_check_save_path + send_to_check_fileName+".jpg") # ไฟล์ที่ต้องการตรวจสอบ
send_to_check_face_encoding = face_recognition.face_encodings(send_to_check_Pic)[0] # เข้ารหัสหน้าตา
results = face_recognition.compare_faces([face_encoding], send_to_check_face_encoding) # ทำการเปรียบเทียบหน้าตาที่เข้ารหัสไว้ด้วย Face Recognition

print(arg1 + " " + arg2)
if results[0] == True:
  print("Checked!")
else:
  print("Imposter!!")

# print(fileName)


