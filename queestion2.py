import boto3
import os
import sys
import uuid
from PIL import Image
import PIL.Image
     

     
def resize_image(image_path, resized_path):
        basewidth=200
        with Image.open(image_path) as image:
                wpercent = (basewidth / float(image.size[0]))
                hsize = int((float(image.size[1]) * float(wpercent)))
                img = image.resize((basewidth, hsize), PIL.Image.ANTIALIAS)
                img.save(resized_path)
     
def lambda_handler(event, context):
    s3_client = boto3.client('s3',region_name='us-east-1')
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    download_path = '/tmp/{}{}'.format(uuid.uuid4(), key)
    upload_path = '/tmp/resized-{}'.format(key)
    
    s3_client.download_file(bucket, key, download_path)
    resize_image(download_path, upload_path)
    s3_client.upload_file(upload_path, 'kishan12', 'resize_{}'.format(key))
