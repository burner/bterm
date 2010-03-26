/* bterm a wmii like terminal emulator
 * forked from vala-terminal
 *
 * (C) 2007-2010 Michael 'Mickey' Lauer <mickey@vanille-media.de>
 * (C) 2009 Aapo Rantalainen
 * (C) 2010 Robert "BuRnEr" Schadek
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 */

using GLib;
using Gtk;
using Gdk;

public class BTerm.MainWindow : Gtk.Window {
	private static string initial_command;
	private static string[] initial_command_line;
	private HBox mainBox;
	private VBox[] list;
	uint count;
	private BTerm.LList root;

	public MainWindow() {
		this.root = new BTerm.LList();
		this.root.create_item();
		var layout = this.root.get_layout();
		count = 1;
		//this.list[0].add(tmp);
		//this.mainBox.add(tmp);
		
		destroy.connect(Gtk.main_quit);
		//key_press_event.connect(key_press_event_cb);
		//term.destroy.connect(Gtk.main_quit);
		add(layout);
		//set_focus_child(tmp);
		
		//this.set_focus_child(this.list[0].get_children());
		set_default_size(640, 400);
	}

	public void setup_command( string command ) {
		initial_command = command + "\n";
	}

	public static void add_term(uint id) {
		stdout.printf("called by term with id %u\n", id);
	}

	public void run() {
		// FIXME default focus needs to be on the terminal (in order to play nice with on-screen keyboards)
		show_all();
		Gtk.main();
	}

	static int main (string[] args) {
	  /*FIX. GTK.init_with_args doesn't work. http://bugzilla.gnome.org/show_bug.cgi?id=547135 */
		Gtk.init( ref args );

		var window = new BTerm.MainWindow();
		if(initial_command != null) {
			window.setup_command( initial_command );
		} else if(initial_command_line != null) {
			initial_command = string.joinv( " ", initial_command_line );
			window.setup_command( initial_command );
		}

		window.run();
		return 0;
	}
}
