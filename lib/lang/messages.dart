import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_EN': {
          "app_bar_title": "To Dos",
          "pending": "Pending To Dos",
          "completed": "Completed To Dos",
          "id": "ID:",
          "task": "Task:",
          "description": "Description:",
          "add_to_do": "Add To Do",
          "go_back": "Go Back",
          "to_do_added": "To Do Added",
          "add":"Add"
        },
        'fa_FA': {
          "app_bar_title": "وظایف",
          "pending": "در انتظار انجام کارها",
          "completed": "کارهای تکمیل شده",
          "id": "کد:",
          "task": "کار:",
          "description": "توضیحات:",
          "add_to_do": "اضافه کردن کار",
          "go_back": "برگشت",
          "to_do_added": "کار اضافه شد",
          "add":"اضافه کردن"
        }
      };
}
