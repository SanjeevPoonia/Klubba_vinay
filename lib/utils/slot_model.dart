
class SlotModel{


  static String learner_stages='';
  static String category_attribute='';
  static String category='';

  static String setLearnerValue(String token)
  {
    learner_stages=token;
    return learner_stages;
  }

  static String setAttributeValue(String slugValue)
  {
    category_attribute=slugValue;
    return category_attribute;
  }
  static String setCategoryValue(String slugValue)
  {
    category=slugValue;
    return category;
  }



}
