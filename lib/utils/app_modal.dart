
class AppModel{


  static String userToken='';
  static bool showHint=false;
  static String slug='';
  static Map<String,dynamic>? fileData;
  static Map<String,dynamic> copyData={};
  static Map<String,dynamic> groupData={};
  static String kandyDiscount='';
  static bool kandyEnabled=false;
  static Map<String,dynamic> userData={};
  static List<dynamic> slotDataList=[];

  static String setTokenValue(String token)
  {
    userToken=token;
    return userToken;
  }
  static bool setHintValue(bool hint)
  {
    showHint=hint;
    return showHint;
  }

  static bool setKandySelectValue(bool hint)
  {
    kandyEnabled=hint;
    return kandyEnabled;
  }


  static Map<String,dynamic> setUserData(Map<String,dynamic> userDetails)
  {
    userData=userDetails;
    return userData;
  }
  static List<dynamic> setSlotData(List<dynamic> data)
  {
    slotDataList=data;
    return slotDataList;
  }

  static String setKandyDiscount(String discount)
  {
    kandyDiscount=discount;
    return kandyDiscount;

  }

  static String setSlugValue(String slugValue)
  {
    slug=slugValue;
    return slug;
  }

  static Map<String,dynamic> setFileData(Map<String,dynamic> data)
  {
    fileData=data;
    return fileData!;
  }
  static Map<String,dynamic> setGroupData(Map<String,dynamic> data)
  {
    groupData=data;
    return groupData!;
  }
  static Map<String,dynamic> setCopyData(Map<String,dynamic> data)
  {
    copyData=data;
    return copyData!;
  }


}
