from minio import Minio
import os
from pathlib import Path
# пример записи строковых данных в хранилище через поток
import io

# Launch the MinIO Server
# minio server ~/minio --console-address :9090
# https://min.io/docs/minio/linux/index.html

class DB_Minio():
    def __init__(self):
        try:
            # Установка соединения
            self.client = Minio(
                # адрес сервера
                endpoint="172.16.93.158:9000",
                # логин админа
                access_key='minioadmin',
                # пароль админа
                secret_key='minioadmin',
                # опциональный параметр, отвечающий за вкл/выкл защищенное TLS соединение
                secure=False
            )
        except Exception as ex:
            print(f'[ERROR] Не подключить к Minio. \n{ex}')


    # Для создания бакета
    def add_new_bucket(self, bucket_name: str):
        try:
            self.client.make_bucket(bucket_name=bucket_name)
            print(f'[INFO] [Успешно добавлен бакет [{bucket_name}]')
        except Exception as ex:
            print(f'[ERROR] Не удалось добавить бакет. \n{ex}')

    # Проверка наличия бакетов и выводит список
    def check_bucket_exists(self, bucket_name):
        info_bucket = self.client.bucket_exists(bucket_name)
        if (info_bucket):
            print(f'[{info_bucket}] Бакет "{bucket_name}" существует')
        else:
            print(f'[{info_bucket}] Бакет "{bucket_name}" не существует')

    # Для удаления бакета
    def remove_bucket(self, bucket_name: str):
        try:
            self.client.remove_bucket(bucket_name=bucket_name)
            print(f'[INFO] [Успешно удалено бакет [{bucket_name}]')
        except Exception as ex:
            print(f'[ERROR] Не удалось удалить бакет. \n{ex}')

    # Для записи объекта в хранилище из файла
    def fput_object(self, bucket_name: str, object_name: str, file_path: str):
        try:
            self.client.fput_object(
                # имя бакета
                bucket_name=bucket_name,
                # имя для нового файла в хринилище
                object_name=object_name,
                # и путь к исходному файлу
                file_path=file_path
            )
        except Exception as ex:
            print(f'[ERROR] Не удалось записать объект в хранилище из файла. \n{ex}')

    # Для выгрузки объекта из хранилища в ваш файл
    def fget_object(self, bucket_name: str, object_name: str, file_path: str):
        try:
            self.client.fget_object(
                # имя бакета
                bucket_name=bucket_name,
                # имя файла в хранилище
                object_name=object_name,
                # и путь к файлу для записи
                file_path=file_path
            )
        except Exception as ex:
            print(f'[ERROR] Не удалось взять объект из хранилища в файл. \n{ex}')

    # Выводит информацию о объектах
    def stat_object(self, bucket_name: str, object_name: str):
        try:
            result = self.client.stat_object(
                # имя бакета
                bucket_name=bucket_name,
                # имя файла в хранилище
                object_name=object_name
            )
            print(
                "last-modified: {0}, size: {1}".format(
                    result.last_modified, result.size,
                ),
            )
        except Exception as ex:
            print(f'[ERROR] Не удалось получить данные о объектах. \n{ex}')

    # Выводит список объектов
    def list_objects(self, bucket_name: str):
        try:
            objects = self.client.list_objects(
                bucket_name=bucket_name
            )
            for obj in objects:
                print(obj)
        except Exception as ex:
            print(f'[ERROR] Не удалось получить данные о объектах. \n{ex}')

    # Получает временный url ссылка объекта
    # Получите предварительно заданный URL-адрес объекта для HTTP-метода, время истечения срока действия и пользовательские параметры запроса.
    # https://min.io/docs/minio/linux/developers/python/API.html#get_presigned_url
    def get_presigned_url(self, method: str, bucket_name: str, object_name: str):
        try:
            url = self.client.get_presigned_url(
                method=method,
                bucket_name=bucket_name,
                object_name=object_name
            )
            print(url)
        except Exception as ex:
            print(f'[ERROR] Не удалось получить данные о объектах. \n{ex}')

DB = DB_Minio()
# DB.check_bucket_exists(bucket_name='mars')
# DB.stat_object(bucket_name='mars', object_name='Farsida.jpg')
# DB.list_objects(bucket_name='mars')
DB.get_presigned_url(method='GET', bucket_name='mars', object_name='Farsida.jpg')