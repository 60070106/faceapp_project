<<<<<<< HEAD
#!/usr/bin/env python
# -*-coding=utf-8 -*-

from PIL import Image
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

save_path = 'C:/xampp/htdocs/RestApi/public/' #ตำแหน่งไฟล์ที่บันทึก
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
=======
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
import math

name = sys.argv[1] #ชื่อที่รับเข้ามา
surname = sys.argv[2] #นามสกุลที่รับเข้ามา

payload = {'name': name, 'surname': surname} #ส่งข้อมูลเพื่อตรวจสอบจาก database ที่มีอยู่
send_to_check_response = requests.get("http://localhost:8000/api/getpicture", params=payload) #ดึง response จาก rest api เพื่อนำมาตรวจสอบ

send_to_check_save_path = 'C:/xampp/htdocs/RestApi/public/image/checkimg/' #ตำแหน่งไฟล์ที่บันทึก
send_to_check_now = datetime.now()
send_to_check_current_time = send_to_check_now.strftime("%d-%m-%Y(%H-%M-%S)")
send_to_check_fileName = name+"_"+surname+"_"+send_to_check_current_time #ชื่อไฟล์เป็นชื่อ-นามสกุล และวันและเวลาที่เข้าทำการตรวจสอบ

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

database_save_path = 'C:/xampp/htdocs/RestApi/public/image/querry_fromDB/' #ดึงข้อมูลจาก database
database_now = datetime.now()
database_current_time = database_now.strftime("%d-%m-%Y(%H-%M-%S)")
database_fileName = name+"_"+surname+"_" + database_current_time 

database_completeName = os.path.join(database_save_path, database_fileName +".jpg")
database_fh = open(database_completeName, "wb")
database_fh.write(base64.b64decode(database_response.text))
database_fh.close()

database_img = Image.open(database_save_path + database_fileName+".jpg")
database_img.show()

#
#
#
#

database_Pic = face_recognition.load_image_file(database_save_path + database_fileName+".jpg") # โหลดรูปจาก database
face_encoding = face_recognition.face_encodings(database_Pic)[0] # เข้ารหัสหน้าตา
send_to_check_Pic = face_recognition.load_image_file(send_to_check_save_path + send_to_check_fileName+".jpg") # ไฟล์ที่ต้องการตรวจสอบ
send_to_check_face_encoding = face_recognition.face_encodings(send_to_check_Pic)[0] # เข้ารหัสหน้าตา
results = face_recognition.compare_faces([face_encoding], send_to_check_face_encoding) # ทำการเปรียบเทียบหน้าตาที่เข้ารหัสไว้ด้วย Face Recognition

face_distances = face_recognition.face_distance([face_encoding], send_to_check_face_encoding)

def face_distance_to_conf(face_distance, face_match_threshold=0.5):
  if face_distance > face_match_threshold:
    range = (1.0 - face_match_threshold)
    linear_val = (1.0 - face_distance) / (range * 2.0)
    print("Unknown")
    return linear_val * 100
  else:
    range = face_match_threshold
    linear_val = 1.0 - (face_distance / (range * 2.0))
    print("It's same person")
    return (linear_val + ((1.0 - linear_val) * math.pow((linear_val - 0.5) * 2, 0.2))) * 100

percentage = face_distance_to_conf(face_distances)[0]
print(f'{percentage:.2f}' + '%')
>>>>>>> 5bf2a537d4958a1e8ecf3ce857bd9ae8b42329eb
