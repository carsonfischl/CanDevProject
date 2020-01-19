import turicreate

class TitleModel:

  def __init__(self):
    self.model = turicreate.load_model('title_knn_model')
  
  def getModel():
    return self.model

  def predict(query):
    return self.model.query(query)