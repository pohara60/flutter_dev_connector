enum AlertType {
  Primary,
  Success,
  Danger,
}

class Alert {
  final String id;
  final AlertType alertType;
  final String msg;

  Alert(this.alertType, this.msg) : this.id = DateTime.now().toString();
}
