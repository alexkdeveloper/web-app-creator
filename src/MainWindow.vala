public class WAC.MainWindow : Adw.ApplicationWindow {

    private string directory_path;
    private string item;

    private Gtk.Stack stack;
    private Gtk.ListBox list_box;
    private Gtk.Box vbox_list_page;
    private Gtk.Box vbox_edit_page;
    private Adw.Clamp clamp_create_page;
    private Adw.ComboRow combo;
    private Adw.EntryRow entry_name;
    private Adw.EntryRow entry_address;
    private Adw.EntryRow entry_icon;
    private Adw.EntryRow entry_categories;
    private Adw.EntryRow entry_comment;
    private Adw.EntryRow entry_other_browser;
    private Gtk.SearchEntry entry_search;
    private Gtk.TextView text_view;
    private Gtk.Button back_button;
    private Gtk.Button delete_button;
    private Gtk.Button edit_button;
    private Gtk.Button save_button;
    private Gtk.Button clear_button;
    private Gtk.Button button_create;
    private Gtk.Button button_show_all;
    private Gtk.Button search_button;
    private Gtk.Button open_icon;
    private Adw.ToastOverlay overlay;

    public MainWindow (Adw.Application application) {
        Object (
            application: application,
            title: "Web App Creator",
            default_height: 500,
            default_width: 500
        );
    }

    construct {
        back_button = new Gtk.Button ();
            back_button.vexpand = false;
            back_button.set_icon_name ("go-previous-symbolic");
            back_button.set_tooltip_text (_("Back"));
        

        delete_button = new Gtk.Button ();
            delete_button.vexpand = false;
            delete_button.set_icon_name ("edit-delete-symbolic");
            delete_button.set_tooltip_text (_("Delete"));

        edit_button = new Gtk.Button ();
            edit_button.vexpand = false;
            edit_button.set_icon_name ("document-edit-symbolic");
            edit_button.set_tooltip_text (_("Edit"));


        save_button = new Gtk.Button ();
            save_button.vexpand = false;
            save_button.set_icon_name ("document-save-symbolic");
            save_button.set_tooltip_text (_("Save"));

        clear_button = new Gtk.Button ();
           clear_button.vexpand = false;
           clear_button.set_icon_name ("edit-clear-symbolic");
           clear_button.set_tooltip_text (_("Clean"));

        search_button = new Gtk.Button ();
            search_button.vexpand = false;
            search_button.set_icon_name("edit-find-symbolic");

        var button_create_content = new Adw.ButtonContent ();
        button_create_content.set_icon_name ("list-add-symbolic");
        button_create_content.set_label (_("Create App"));
        button_create = new Gtk.Button ();
        button_create.set_child (button_create_content);

        var button_show_all_content = new Adw.ButtonContent ();
        button_show_all_content.set_icon_name ("folder-open-symbolic");
        button_show_all_content.set_label (_("Show All"));
        button_show_all = new Gtk.Button ();
        button_show_all.set_child (button_show_all_content);
        
        var headerbar = new Adw.HeaderBar ();
        headerbar.pack_start (back_button);
        headerbar.pack_start (edit_button);
        headerbar.pack_start (delete_button);
        headerbar.pack_start (save_button);
        headerbar.pack_start (clear_button);
        headerbar.pack_start (button_show_all);
        headerbar.pack_end (button_create);
        headerbar.pack_end (search_button);

        back_button.clicked.connect (on_back_clicked);
        delete_button.clicked.connect (on_delete_clicked);
        edit_button.clicked.connect (on_edit_clicked);
        save_button.clicked.connect (on_save_clicked);
        clear_button.clicked.connect (on_clear_clicked);
        button_create.clicked.connect (on_create_file);
        button_show_all.clicked.connect (go_to_list_page_from_create_page);
        search_button.clicked.connect(()=>{
               if(entry_search.is_visible()){
                  entry_search.hide();
                  entry_search.set_text("");
                  if(item != null){
                     list_box.select_row(list_box.get_row_at_index(get_index(item)));
                  }
               }else{
                  entry_search.show();
                  entry_search.grab_focus();
               }
            });

        set_buttons_on_create_page ();

         var clear_name = new Gtk.Button();
        clear_name.set_icon_name("edit-clear-symbolic");
        clear_name.add_css_class("destructive-action");
        clear_name.add_css_class("circular");
        clear_name.valign = Gtk.Align.CENTER;
        clear_name.visible = false;
        clear_name.clicked.connect((event) => {
            on_clear_entry(entry_name);
        });

        entry_name = new Adw.EntryRow ();
        entry_name.set_title (_("Name"));
        entry_name.add_suffix (clear_name);
        entry_name.changed.connect((event) => {
            on_entry_change(entry_name, clear_name);
        });

         var clear_address = new Gtk.Button();
        clear_address.set_icon_name("edit-clear-symbolic");
        clear_address.add_css_class("destructive-action");
        clear_address.add_css_class("circular");
        clear_address.valign = Gtk.Align.CENTER;
        clear_address.visible = false;
        clear_address.clicked.connect((event) => {
            on_clear_entry(entry_address);
        });

        entry_address = new Adw.EntryRow ();
        entry_address.set_title (_("Address"));
        entry_address.add_suffix (clear_address);
        entry_address.changed.connect((event) => {
            on_entry_change(entry_address, clear_address);
        });

        open_icon = new Gtk.Button();
        open_icon.set_icon_name("folder-open-symbolic");
        open_icon.add_css_class("suggested-action");
        open_icon.add_css_class("circular");
        open_icon.valign = Gtk.Align.CENTER;
        open_icon.clicked.connect (on_open_icon);

          var clear_icon = new Gtk.Button();
        clear_icon.set_icon_name("edit-clear-symbolic");
        clear_icon.add_css_class("destructive-action");
        clear_icon.add_css_class("circular");
        clear_icon.valign = Gtk.Align.CENTER;
        clear_icon.visible = false;
        clear_icon.clicked.connect((event) => {
            on_clear_entry(entry_icon);
        });

        entry_icon = new Adw.EntryRow ();
        entry_icon.set_title (_("Icon"));
        entry_icon.add_suffix (open_icon);
        entry_icon.add_suffix (clear_icon);
        entry_icon.changed.connect((event) => {
            on_entry_change(entry_icon, clear_icon);
        });

          var clear_categories = new Gtk.Button();
        clear_categories.set_icon_name("edit-clear-symbolic");
        clear_categories.add_css_class("destructive-action");
        clear_categories.add_css_class("circular");
        clear_categories.valign = Gtk.Align.CENTER;
        clear_categories.visible = false;
        clear_categories.clicked.connect((event) => {
            on_clear_entry(entry_categories);
        });

        entry_categories = new Adw.EntryRow ();
        entry_categories.set_title (_("Categories"));
        entry_categories.add_suffix (clear_categories);
        entry_categories.changed.connect((event) => {
            on_entry_change(entry_categories, clear_categories);
        });
        
          var clear_comment = new Gtk.Button();
        clear_comment.set_icon_name("edit-clear-symbolic");
        clear_comment.add_css_class("destructive-action");
        clear_comment.add_css_class("circular");
        clear_comment.valign = Gtk.Align.CENTER;
        clear_comment.visible = false;
        clear_comment.clicked.connect((event) => {
            on_clear_entry(entry_comment);
        });
        
        entry_comment = new Adw.EntryRow ();
        entry_comment.set_title (_("Comment"));
        entry_comment.add_suffix (clear_comment);
        entry_comment.changed.connect((event) => {
            on_entry_change(entry_comment, clear_comment);
        });
        
        string[] browsers = {"Firefox","Chromium","Yandex Browser","Google Chrome","Brave","Epiphany","Vivaldi","Falkon","Microsoft Edge"};

        Gtk.StringList model = new Gtk.StringList(browsers);

        combo = new Adw.ComboRow ();
        combo.set_title (_("Browser"));
        combo.set_model (model);
        combo.set_selectable (false);
        combo.set_selected (0);

         var clear_other_browser = new Gtk.Button();
        clear_other_browser.set_icon_name("edit-clear-symbolic");
        clear_other_browser.add_css_class("destructive-action");
        clear_other_browser.add_css_class("circular");
        clear_other_browser.valign = Gtk.Align.CENTER;
        clear_other_browser.visible = false;
        clear_other_browser.clicked.connect((event) => {
            on_clear_entry(entry_other_browser);
        });

        entry_other_browser = new Adw.EntryRow ();
        entry_other_browser.set_title (_("Other browser"));
        entry_other_browser.add_suffix (clear_other_browser);
        entry_other_browser.changed.connect((event) => {
            on_entry_change(entry_other_browser, clear_other_browser);
        });

        var list_box_create_page = new Gtk.ListBox ();
        list_box_create_page.add_css_class("boxed-list");
        list_box_create_page.append (entry_name);
        list_box_create_page.append (entry_address);
        list_box_create_page.append (entry_icon);
        list_box_create_page.append (entry_categories);
        list_box_create_page.append (entry_comment);
        list_box_create_page.append (combo);
        list_box_create_page.append (entry_other_browser);

         clamp_create_page = new Adw.Clamp(){
            tightening_threshold = 100,
            valign = Gtk.Align.CENTER,
            margin_top = 15,
            margin_bottom = 15
        };
        clamp_create_page.set_child(list_box_create_page);

        list_box = new Gtk.ListBox ();
        list_box.vexpand = true;
        list_box.add_css_class("boxed-list");
        list_box.row_selected.connect(on_select_item);
        var scroll = new Gtk.ScrolledWindow () {
            propagate_natural_height = true,
            propagate_natural_width = true
        };
         var clamp = new Adw.Clamp(){
            tightening_threshold = 100,
            margin_top = 15,
            margin_bottom = 15
        };
        clamp.set_child(list_box);
        scroll.set_child(clamp);

        entry_search = new Gtk.SearchEntry();
        entry_search.hexpand = true;
        entry_search.changed.connect(show_desktop_files);
        entry_search.margin_start = 35;
        entry_search.margin_end = 35;
        entry_search.margin_top = 15;
        entry_search.hide();

        vbox_list_page = new Gtk.Box (Gtk.Orientation.VERTICAL,0);
        vbox_list_page.append (entry_search);
        vbox_list_page.append (scroll);

        text_view = new Gtk.TextView () {
            editable = true,
            cursor_visible = true,
            wrap_mode = Gtk.WrapMode.WORD
        };

        var scroll_edit_page = new Gtk.ScrolledWindow ();
        scroll_edit_page.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
        scroll_edit_page.set_vexpand(true);
        scroll_edit_page.set_child (text_view);

        vbox_edit_page = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        vbox_edit_page.margin_top = 20;
        vbox_edit_page.margin_bottom = 20;
        vbox_edit_page.margin_start = 20;
        vbox_edit_page.margin_end = 20;
        vbox_edit_page.append (scroll_edit_page);

        stack = new Gtk.Stack () {
            transition_duration = 600,
            transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT,
        };

        stack.add_child (clamp_create_page);
        stack.add_child (vbox_list_page);
        stack.add_child (vbox_edit_page);
        stack.visible_child = clamp_create_page;

        overlay = new Adw.ToastOverlay ();
        overlay.set_child (stack);

        var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        box.append(headerbar);
        box.append(overlay);
        set_content(box);

        directory_path = Environment.get_home_dir () + "/.local/share/applications";
        GLib.File file = GLib.File.new_for_path (directory_path);
        if (!file.query_exists ()) {
            alert ("",_("Error!\nPath %s does not exists!\nThe program will not be able to perform its functions.").printf(directory_path));
            button_create.sensitive = false;
            button_show_all.sensitive = false;
        }
    }
    
    private void on_clear_entry(Adw.EntryRow entry){
    entry.set_text("");
    entry.grab_focus();
}

   private void on_entry_change(Adw.EntryRow entry, Gtk.Button clear){
    if (!is_empty(entry.get_text())) {
          if (entry == entry_icon) {
            open_icon.set_visible(false);
        }
        clear.set_visible(true);
    } else {
         if (entry == entry_icon) {
            open_icon.set_visible(true);
        }
        clear.set_visible(false);
    }
}

    private void on_open_icon () {
            var filter = new Gtk.FileFilter ();
            filter.add_mime_type ("image/jpeg");
            filter.add_mime_type ("image/png");
            filter.add_mime_type ("image/svg+xml");
            filter.add_mime_type ("image/x-xpixmap");
            filter.add_mime_type ("image/vnd.microsoft.icon");

            var filechooser = new Gtk.FileDialog () {
                title = _("Select the icon"),
                modal = true,
                default_filter = filter
            };
            filechooser.open.begin (this, null, (obj, res) => {
                try {
                    var file = filechooser.open.end (res);
                    if (file == null) {
                        return;
                    }
                    entry_icon.text = file.get_path ();
                } catch (Error e) {
                    warning ("Failed to select icon file: %s", e.message);
                }
            });
    }

    private void on_create_file () {
        if (is_empty (entry_name.text)) {
            set_toast (_("Enter the name"));
            entry_name.grab_focus ();
            return;
        }

        GLib.File file = GLib.File.new_for_path (directory_path + "/" + entry_name.text.strip () + ".desktop");
        if (file.query_exists ()) {
            alert (_("App with the same name already exists"),"");
            entry_name.grab_focus ();
            return;
        }
        var dialog_create_desktop_file = new Adw.MessageDialog(this, _("Create app %s?").printf (entry_name.get_text()), "");
            dialog_create_desktop_file.add_response("cancel", _("_Cancel"));
            dialog_create_desktop_file.add_response("ok", _("_OK"));
            dialog_create_desktop_file.set_default_response("ok");
            dialog_create_desktop_file.set_close_response("cancel");
            dialog_create_desktop_file.set_response_appearance("ok", SUGGESTED);
            dialog_create_desktop_file.show();
            dialog_create_desktop_file.response.connect((response) => {
                if (response == "ok") {
                    create_desktop_file();
                }
                dialog_create_desktop_file.close();
            });
    }

    private void on_edit_clicked () {
          var selection = list_box.get_selected_row();
           if (!selection.is_selected()) {
               set_toast(_("Choose a file"));
               return;
           }
        stack.visible_child = vbox_edit_page;
        set_buttons_on_edit_page ();
        string text;
        try {
            FileUtils.get_contents (directory_path + "/" + item, out text);
            text_view.buffer.text = text;
        } catch (Error e) {
            stderr.printf (_("Error: %s") + "\n", e.message);
        }
    }

    private void on_back_clicked () {
        if(stack.get_visible_child ()==vbox_edit_page){
            stack.visible_child = vbox_list_page;
            set_buttons_on_list_page ();
        }else{
            stack.visible_child = clamp_create_page;
            set_buttons_on_create_page ();
        }
    }

    private void go_to_list_page_from_create_page () {
        stack.visible_child = vbox_list_page;
        set_buttons_on_list_page ();
        show_desktop_files ();
    }

    private void on_save_clicked () {
        if (is_empty (text_view.buffer.text)) {
            set_toast (_("Nothing to save"));
            return;
        }

        GLib.File file = GLib.File.new_for_path (directory_path + "/" + item);
        
         var dialog_save_file = new Adw.MessageDialog(this, _("Save file %s?").printf (file.get_basename ()), "");
            dialog_save_file.add_response("cancel", _("_Cancel"));
            dialog_save_file.add_response("ok", _("_OK"));
            dialog_save_file.set_default_response("ok");
            dialog_save_file.set_close_response("cancel");
            dialog_save_file.set_response_appearance("ok", SUGGESTED);
            dialog_save_file.show();
            dialog_save_file.response.connect((response) => {
                if (response == "ok") {
                    try {
                      FileUtils.set_contents (file.get_path (), text_view.buffer.text);
                   } catch (Error e) {
                      stderr.printf (_("Error: %s") + "\n", e.message);
                    }
                }
                dialog_save_file.close();
            });
    }

    private void on_delete_clicked () {
          var selection = list_box.get_selected_row();
           if (!selection.is_selected()) {
               set_toast(_("Choose a file"));
               return;
           }

        GLib.File file = GLib.File.new_for_path (directory_path + "/" + item);

        var dialog_delete_file = new Adw.MessageDialog(this, _("Delete file %s?").printf (file.get_basename ()), "");
            dialog_delete_file.add_response("cancel", _("_Cancel"));
            dialog_delete_file.add_response("ok", _("_OK"));
            dialog_delete_file.set_default_response("ok");
            dialog_delete_file.set_close_response("cancel");
            dialog_delete_file.set_response_appearance("ok", SUGGESTED);
            dialog_delete_file.show();
            dialog_delete_file.response.connect((response) => {
                if (response == "ok") {
                     FileUtils.remove (directory_path + "/" + item);
                   if (file.query_exists ()) {
                      set_toast (_("Delete failed"));
                   } else {
                      show_desktop_files ();
                      text_view.buffer.text = "";
                   }
                }
                dialog_delete_file.close();
            });
    }

    private void on_clear_clicked () {
        if (is_empty (text_view.buffer.text)) {
            set_toast (_("Nothing to clear"));
            return;
        }
        
         var dialog_clear_editor = new Adw.MessageDialog(this, _("Clear the editor?"), "");
            dialog_clear_editor.add_response("cancel", _("_Cancel"));
            dialog_clear_editor.add_response("ok", _("_OK"));
            dialog_clear_editor.set_default_response("ok");
            dialog_clear_editor.set_close_response("cancel");
            dialog_clear_editor.set_response_appearance("ok", SUGGESTED);
            dialog_clear_editor.show();
            dialog_clear_editor.response.connect((response) => {
                if (response == "ok") {
                   text_view.buffer.text = "";
                }
                dialog_clear_editor.close();
            });
    }
     
     private string browser(){
     string b = "";
         switch (combo.get_selected ()) {
             case 0:
             b = "firefox";
             break;
             case 1:
             b = "chromium";
             break;
             case 2:
             b = "yandex-browser";
             break;
             case 3:
             b = "google-chrome";
             break;
             case 4:
             b = "brave-browser";
             break;
             case 5:
             b = "epiphany";
             break;
             case 6:
             b = "vivaldi";
             break;
             case 7:
             b = "falkon";
             break;
             case 8:
             b = "microsoft-edge";
             break;
         }
         return b;
     }
     
    private void on_select_item () {
        var selection = list_box.get_selected_row();
           if (!selection.is_selected()) {
               return;
           }
          GLib.Value value = "";
          selection.get_property("title", ref value);
          item = value.get_string();
       }

    private void create_desktop_file () {
        string brows;
        if(is_empty(entry_other_browser.get_text())){
            brows = browser();
        }else{
            brows = entry_other_browser.get_text();
        }
        string addr = entry_address.text.strip ();
        if(!addr.contains ("http")&&!addr.contains ("://")){
            addr = "https://" + addr;
        }
        string desktop_file = "[Desktop Entry]
Encoding=UTF-8
Type=Application
NoDisplay=" + "false" + "
Terminal=" + "false" + "
Exec=" +brows+" --app="+ addr + "
Icon=" + entry_icon.text.strip () + "
Name=" + entry_name.text.strip () + "
Comment=" + entry_comment.text.strip () + "
Categories=" + entry_categories.text.strip ();
        string path = directory_path + "/" + entry_name.text + ".desktop";
        try {
            FileUtils.set_contents (path, desktop_file);
        } catch (Error e) {
            stderr.printf (_("Error: %s") + "\n", e.message);
        }

        GLib.File file = GLib.File.new_for_path (path);
        if (file.query_exists ()) {
            alert (_("App has been successfully created!"),"");
        } else {
            alert (_("Error! Could not create app"),"");
        }
    }

    private bool is_empty (string str) {
        return str.strip ().length == 0;
    }

    private void show_desktop_files () {
        var list = new GLib.List<string> ();
            try {
            Dir dir = Dir.open (directory_path, 0);
            string? name = null;
            while ((name = dir.read_name ()) != null) {
                if(entry_search.is_visible()){
                    if(name.down().contains(entry_search.get_text().down())){
                       list.append(name);
                    }
                    }else{
                       list.append(name);
                }
            }
        } catch (FileError err) {
            stderr.printf (err.message);
        }
        for (
            var child = (Gtk.ListBoxRow) list_box.get_last_child ();
                child != null;
                child = (Gtk.ListBoxRow) list_box.get_last_child ()
        ) {
            list_box.remove(child);
        }
           foreach (string item in list) {
                var row = new Adw.ActionRow () {
                title = item
            };
            list_box.append(row);
           }
    }

     private int get_index(string item){
            int index_of_item = 0;
            try {
            Dir dir = Dir.open (directory_path, 0);
            string? name = null;
            int index = 0;
            while ((name = dir.read_name ()) != null) {
                index++;
                if(name == item){
                  index_of_item = index - 1;
                  break;
                }
            }
        } catch (FileError err) {
            stderr.printf (err.message);
          }
          return index_of_item;
        }

    private void set_widget_visible (Gtk.Widget widget, bool visible) {
        widget.visible = !visible;
        widget.visible = visible;
    }

    private void set_buttons_on_edit_page () {
        set_widget_visible (back_button, true);
        set_widget_visible (save_button, true);
        set_widget_visible (delete_button, false);
        set_widget_visible (edit_button, false);
        set_widget_visible (clear_button, true);
        set_widget_visible (button_create, false);
        set_widget_visible (button_show_all, false);
        set_widget_visible (search_button, false);
    }

    private void set_buttons_on_list_page () {
        set_widget_visible (back_button, true);
        set_widget_visible (save_button, false);
        set_widget_visible (delete_button, true);
        set_widget_visible (edit_button, true);
        set_widget_visible (clear_button, false);
        set_widget_visible (button_create, false);
        set_widget_visible (button_show_all, false);
        set_widget_visible (search_button, true);
    }

    private void set_buttons_on_create_page () {
        set_widget_visible (back_button, false);
        set_widget_visible (save_button, false);
        set_widget_visible (delete_button, false);
        set_widget_visible (edit_button, false);
        set_widget_visible (clear_button, false);
        set_widget_visible (button_create, true);
        set_widget_visible (button_show_all, true);
        set_widget_visible (search_button, false);
    }

    private void set_toast(string str){
        var toast = new Adw.Toast (str);
        toast.set_timeout (3);
        overlay.add_toast (toast);
    }

     private void alert (string heading, string body){
            var dialog_alert = new Adw.MessageDialog(this, heading, body);
            if (body != "") {
                dialog_alert.set_body(body);
            }
            dialog_alert.add_response("ok", _("_OK"));
            dialog_alert.set_response_appearance("ok", SUGGESTED);
            dialog_alert.response.connect((_) => { dialog_alert.close(); });
            dialog_alert.show();
        }
}
