public class WAC.MainWindow : Adw.ApplicationWindow {
    private enum Columns {
        TEXT,
        N_COLUMNS
    }

    private string directory_path;
    private string item;

    private Gtk.Stack stack;
    private Gtk.Box vbox_create_page;
    private Gtk.Box vbox_list_page;
    private Gtk.Box vbox_edit_page;
    private Gtk.ListStore list_store;
    private Gtk.TreeView tree_view;
    private GLib.List<string> list;
    private Gtk.ComboBox combobox;
    private Gtk.Entry entry_name;
    private Gtk.Entry entry_address;
    private Gtk.Entry entry_icon;
    private Gtk.Entry entry_categories;
    private Gtk.Entry entry_comment;
    private Gtk.Entry entry_other_browser;
    private Gtk.TextView text_view;
    private Gtk.Button back_button;
    private Gtk.Button delete_button;
    private Gtk.Button edit_button;
    private Gtk.Button save_button;
    private Gtk.Button clear_button;
    private Gtk.Button button_create;
    private Gtk.Button button_show_all;
    private Adw.ToastOverlay overlay;

    public MainWindow (Adw.Application application) {
        Object (
            application: application,
            title: "Web App Creator",
            default_height: 550,
            default_width: 450
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
        headerbar.pack_end (button_create);
        headerbar.pack_start (button_show_all);

        back_button.clicked.connect (on_back_clicked);
        delete_button.clicked.connect (on_delete_clicked);
        edit_button.clicked.connect (on_edit_clicked);
        save_button.clicked.connect (on_save_clicked);
        clear_button.clicked.connect (on_clear_clicked);
        button_create.clicked.connect (on_create_file);
        button_show_all.clicked.connect (go_to_list_page_from_create_page);

        set_buttons_on_create_page ();

        entry_name = new Gtk.Entry ();
        entry_name.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
        entry_name.icon_press.connect ((pos, event) => {
                entry_name.text = "";
                entry_name.grab_focus ();
        });

        var label_name = new Gtk.Label.with_mnemonic (_("_Name:"));
        label_name.set_xalign(0);

        var vbox_name = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        vbox_name.append (label_name);
        vbox_name.append (entry_name);

        entry_address = new Gtk.Entry ();
        entry_address.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
        entry_address.icon_press.connect ((pos, event) => {
                entry_address.text = "";
                entry_address.grab_focus ();
        });

        var label_address = new Gtk.Label.with_mnemonic (_("_Address:"));
        label_address.set_xalign(0);

        var vbox_address = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        vbox_address.append (label_address);
        vbox_address.append (entry_address);

        entry_icon = new Gtk.Entry ();
        entry_icon.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "document-open-symbolic");
        entry_icon.icon_press.connect ((pos, event) => {
                on_open_icon ();
        });

        var label_icon = new Gtk.Label.with_mnemonic (_("_Icon:"));
        label_icon.set_xalign(0);

        var vbox_icon = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        vbox_icon.append (label_icon);
        vbox_icon.append (entry_icon);

        entry_categories = new Gtk.Entry ();
        entry_categories.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
        entry_categories.icon_press.connect ((pos, event) => {
                entry_categories.text = "";
                entry_categories.grab_focus ();
        });

        var label_categories = new Gtk.Label.with_mnemonic (_("_Categories:"));
        label_categories.set_xalign(0);

        var vbox_categories = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        vbox_categories.append (label_categories);
        vbox_categories.append (entry_categories);

        entry_comment = new Gtk.Entry ();
        entry_comment.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
        entry_comment.icon_press.connect ((pos, event) => {
                entry_comment.text = "";
                entry_comment.grab_focus ();
        });

        var label_comment = new Gtk.Label.with_mnemonic (_("_Comment:"));
        label_comment.set_xalign(0);

        var vbox_comment = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        vbox_comment.append (label_comment);
        vbox_comment.append (entry_comment);
        
        var liststore = new Gtk.ListStore(1, typeof (string));
        Gtk.TreeIter iter;

        liststore.append(out iter);
        liststore.set(iter, 0, "Firefox", -1);
        liststore.append(out iter);
        liststore.set(iter, 0, "Chromium", -1);
        liststore.append(out iter);
        liststore.set(iter, 0, "Yandex Browser", -1);
        liststore.append(out iter);
        liststore.set(iter, 0, "Google Chrome", -1);
        liststore.append(out iter);
        liststore.set(iter, 0, "Brave", -1);
        liststore.append(out iter);
        liststore.set(iter, 0, "Epiphany", -1);
        liststore.append(out iter);
        liststore.set(iter, 0, "Vivaldi", -1);
        liststore.append(out iter);
        liststore.set(iter, 0, "Falkon", -1);
        liststore.append(out iter);
        liststore.set(iter, 0, "Microsoft Edge", -1);
    
        var cellrenderertext = new Gtk.CellRendererText();

        combobox = new Gtk.ComboBox();
        combobox.set_model(liststore);
        combobox.pack_start(cellrenderertext, true);
        combobox.add_attribute(cellrenderertext, "text", 0);
        combobox.set_active(0);
        
        var label_browser = new Gtk.Label.with_mnemonic (_("_Browser:"));
        label_browser.set_xalign(0);

        var vbox_browser = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        vbox_browser.append (label_browser);
        vbox_browser.append (combobox);
        
        entry_other_browser = new Gtk.Entry ();
        entry_other_browser.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "edit-clear-symbolic");
        entry_other_browser.icon_press.connect ((pos, event) => {
                entry_other_browser.text = "";
                entry_other_browser.grab_focus ();
        });

        var label_other_browser = new Gtk.Label.with_mnemonic (_("_Other browser:"));
        label_other_browser.set_xalign(0);

        var vbox_other_browser = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        vbox_other_browser.append (label_other_browser);
        vbox_other_browser.append (entry_other_browser);

        vbox_create_page = new Gtk.Box (Gtk.Orientation.VERTICAL, 20);
        vbox_create_page.append (vbox_name);
        vbox_create_page.append (vbox_address);
        vbox_create_page.append (vbox_icon);
        vbox_create_page.append (vbox_categories);
        vbox_create_page.append (vbox_comment);
        vbox_create_page.append (vbox_browser);
        vbox_create_page.append (vbox_other_browser);

        var text = new Gtk.CellRendererText ();

        var column = new Gtk.TreeViewColumn ();
        column.pack_start (text, true);
        column.add_attribute (text, "markup", Columns.TEXT);

        list_store = new Gtk.ListStore (Columns.N_COLUMNS, typeof (string));
        tree_view = new Gtk.TreeView.with_model (list_store) {
            headers_visible = false
        };
        tree_view.append_column (column);
        tree_view.cursor_changed.connect (on_select_item);

        var scroll_list_page = new Gtk.ScrolledWindow ();
        scroll_list_page.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
        scroll_list_page.set_vexpand(true);
        scroll_list_page.set_child (tree_view);

        vbox_list_page = new Gtk.Box (Gtk.Orientation.VERTICAL,20);
        vbox_list_page.append (scroll_list_page);

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
        vbox_edit_page.append (scroll_edit_page);

        stack = new Gtk.Stack () {
            transition_duration = 600,
            transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT,
        };

        var clamp = new Adw.Clamp ();
        clamp.valign = Gtk.Align.CENTER;
        clamp.tightening_threshold = 100;
        clamp.margin_top = 16;
        clamp.margin_bottom = 36;
        clamp.margin_start = 36;
        clamp.margin_end = 36;
        clamp.set_child (stack);

        overlay = new Adw.ToastOverlay ();
        overlay.set_child (clamp);

        var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        box.append(headerbar);
        box.append(overlay);
        set_content(box);

        stack.add_child (vbox_create_page);
        stack.add_child (vbox_list_page);
        stack.add_child (vbox_edit_page);
        stack.visible_child = vbox_create_page;

        directory_path = Environment.get_home_dir () + "/.local/share/applications";
        GLib.File file = GLib.File.new_for_path (directory_path);
        if (!file.query_exists ()) {
            alert ("",_("Error!\nPath %s does not exists!\nThe program will not be able to perform its functions.").printf(directory_path));
            button_create.sensitive = false;
            button_show_all.sensitive = false;
        }
    }
    
    private void on_open_icon () {
        var file_chooser = new Gtk.FileChooserNative (_("Select the icon"), this, Gtk.FileChooserAction.OPEN,null,null);
            file_chooser.set_modal(true);
            Gtk.FileFilter filter = new Gtk.FileFilter ();
            file_chooser.set_filter (filter);
            filter.add_mime_type ("image/jpeg");
            filter.add_mime_type ("image/png");
            filter.add_mime_type ("image/svg+xml");
            filter.add_mime_type ("image/x-xpixmap");
            filter.add_mime_type ("image/vnd.microsoft.icon");
            file_chooser.response.connect((response) => {
                if (response == Gtk.ResponseType.ACCEPT) {
                    entry_icon.set_text(file_chooser.get_file().get_path());
                }
            });

            file_chooser.show();
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
        var selection = tree_view.get_selection ();
        selection.set_mode (Gtk.SelectionMode.SINGLE);

        Gtk.TreeModel model;
        Gtk.TreeIter iter;
        if (!selection.get_selected (out model, out iter)) {
            set_toast (_("Choose a file"));
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
            stack.visible_child = vbox_create_page;
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
        var selection = tree_view.get_selection ();
        selection.set_mode (Gtk.SelectionMode.SINGLE);

        Gtk.TreeModel model;
        Gtk.TreeIter iter;
        if (!selection.get_selected (out model, out iter)) {
            set_toast (_("Choose a file"));
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
         switch (combobox.get_active()) {
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
        var selection = tree_view.get_selection ();
        selection.set_mode (Gtk.SelectionMode.SINGLE);

        Gtk.TreeModel model;
        Gtk.TreeIter iter;
        if (!selection.get_selected (out model, out iter)) {
            return;
        }

        Gtk.TreePath path = model.get_path (iter);
        var index = int.parse (path.to_string ());
        if (index >= 0) {
            item = list.nth_data (index);
        }
    }

    private void create_desktop_file () {
        string brows;
        if(is_empty(entry_other_browser.get_text())){
            brows = browser();
        }else{
            brows = entry_other_browser.get_text();
        }
        string desktop_file = "[Desktop Entry]
Encoding=UTF-8
Type=Application
NoDisplay=" + "false" + "
Terminal=" + "false" + "
Exec=" +brows+" --app="+ entry_address.text.strip () + "
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
        list_store.clear ();
        list = new GLib.List<string> ();
        try {
            Dir dir = Dir.open (directory_path, 0);
            string? name = null;
            while ((name = dir.read_name ()) != null) {
                list.append (name);
            }
        } catch (FileError err) {
            stderr.printf (err.message);
        }

        Gtk.TreeIter iter;
        foreach (string item in list) {
            list_store.append (out iter);
            list_store.set (iter, Columns.TEXT, item);
        }
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
    }

    private void set_buttons_on_list_page () {
        set_widget_visible (back_button, true);
        set_widget_visible (save_button, false);
        set_widget_visible (delete_button, true);
        set_widget_visible (edit_button, true);
        set_widget_visible (clear_button, false);
        set_widget_visible (button_create, false);
        set_widget_visible (button_show_all, false);
    }

    private void set_buttons_on_create_page () {
        set_widget_visible (back_button, false);
        set_widget_visible (save_button, false);
        set_widget_visible (delete_button, false);
        set_widget_visible (edit_button, false);
        set_widget_visible (clear_button, false);
        set_widget_visible (button_create, true);
        set_widget_visible (button_show_all, true);
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
