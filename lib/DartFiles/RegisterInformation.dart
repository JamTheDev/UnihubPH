import 'dart:io';

class RegisterInformation{
  static String firstName, lastName, userName, userTag, city, province, bio, month, password, day, year;
  static File image;


  String getFirstName(){
    return firstName;
  }

  String getLastName(){
    return lastName;
  }

  String getuserName(){
    return userName;
  }

  String getCity(){
    return city;
  }

  String getProv(){
    return province;
  }

  String getBio(){
    return bio;
  }

  String gDay(){
    return day;
  }
  String gMonth(){
    return month;
  }
  String gYear(){
    return year;
  }

  String getPassword(){
    return password;
  }


}