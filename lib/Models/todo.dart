class Todo{
  int  _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  Todo(this._title,this._date,this._priority,[this._description]);

  Todo.withId(this._id,this._title,this._date,this._priority,[this._description]);

  int get id=>_id;
  String get title=>_title;
  String get description=>_description;
  int get priority=>_priority;
  String get date=>_date;

  set title(String newTitle){
    this._title=newTitle;
  }
  set description(String val){
    this._description=val;
  }
  set date(String val){
    this._date=val;
  }
  set priority(int val){
    this._priority=val;
  }

  Map<String,dynamic> toMap(){
    var map=Map<String,dynamic>();
    if(id!=null){
      map['id']=_id;
    }
    map['title']=_title;
    map['description']=_description;
    map['priority']=_priority;
    map['date']=_date;
    return map;
  }

  Todo.fromMapObject(Map<String,dynamic> map){
    this._id=map['id'];
    this._title=map['title'];
    this._priority=map['priority'];
    this._description=map['description'];
    this._date=map['date'];
  }
}