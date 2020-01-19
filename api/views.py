from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
import turicreate

# Create your views here.
class Courses(APIView):
  """
  Class to handle requests related to the courses endpoint.

  GET => List of courses in the data base
  POST => List of 5 most related courses to the query course
  """
  def get(self, requests):
    return Response({'message': 'Successful query'}, status=status.HTTP_200_OK)

  def post(self, requests):
    title_knn_model = turicreate.load_model('title_knn_model')
    dataset = turicreate.SFrame.read_csv('full_dataset.csv')
    data = requests.data.get('title')
    if data is None or len(data) == 0:
      return Response({'Error': 'No data was provided with the request'}, status=status.HTTP_400_BAD_REQUEST)
    else:
      data = dataset[dataset['Title'] == data]
      nearest_neighbors = title_knn_model.query(data)
      if nearest_neighbors is None or len(nearest_neighbors) == 0:
        return Response({'Error: No course with the corresponding name exists in the dataset'}, status=status.HTTP_400_BAD_REQUEST)
      else:
        response = []
        for entry in nearest_neighbors:
          response.append({'title': entry['reference_label'], 'rank': entry['rank'], 'distance': entry['distance']})
        return Response(response, status=status.HTTP_200_OK)
      return Response({'Success': 'Model was successfully loaded and data is {}'.format(data)}, status=status.HTTP_200_OK)