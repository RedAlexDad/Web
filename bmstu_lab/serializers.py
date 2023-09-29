from bmstu_lab.models import MarsStation, Employee, Location, GeographicalObject, Status, Users, Transport
from rest_framework import serializers


class GeographicalObjectSerializer(serializers.ModelSerializer):
    class Meta:
        # Модель, которую мы сериализуем
        model = GeographicalObject
        # Поля, которые мы сериализуем
        # fields = ['id', 'feature', 'type', 'size', 'describe', 'url_photo', 'status']
        # Либо весь поля записываем
        fields = '__all__'

class GeographicalObjectWithTransportsSerializer(serializers.ModelSerializer):
    class Meta:
        # Модель, которую мы сериализуем
        model = GeographicalObject
        # Поля, которые мы сериализуем
        fields = ['MS_id', 'GO_id', 'GO_feature', 'GO_type', 'GO_size', 'GO_describe', 'GO_url_photo', 'GO_status',
                'L_sequence_number', 'T_id', 'T_name', 'T_type', 'T_describe', 'T_url_photo']


class EmployeeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Employee
        fields = '__all__'

class LocationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Location
        fields = '__all__'

class TransportSerializer(serializers.ModelSerializer):
    class Meta:
        # Модель, которую мы сериализуем
        model = Transport
        # Поля, которые мы сериализуем
        # fields = ['id', 'name', 'type', 'describe', 'url_photo']
        # Либо весь поля записываем
        fields = '__all__'

class MarsStationSerializer(serializers.ModelSerializer):
    class Meta:
        model = MarsStation
        # fields = ['id', 'type_status', 'data_create', 'data_from', 'data_close', 'id_scientist', 'id_transport', 'id_status']
        # Либо весь поля записываем
        fields = '__all__'

class StatusSerializer(serializers.ModelSerializer):
    class Meta:
        model = Status
        fields = '__all__'

class UsersSerializer(serializers.ModelSerializer):
    class Meta:
        model = Users
        fields = '__all__'

