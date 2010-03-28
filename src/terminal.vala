/* bterm a wmii like terminal emulator
 * forked from vala-terminal
 *
 * (C) 2007-2010 Michael 'Mickey' Lauer <mickey@vanille-media.de>
 * (C) 2009 Aapo Rantalainen
 * (C) 2010	Robert "BuRnEr" Schadek
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
using Gdk;
using Gtk;
using Vte;

public class BTerm.BTerminal : VBox {
	private Terminal terminal;
	public signal void selection(bool active);
	private BTerm.Item item;

	//key defines
	private static const string alt_l_key = "Alt_L";
	private static const string strg_l_key = "Control_L";
	private static const string super_l_key = "Super_L";
	private static const string shift_l_key = "Shift_L";
	private static const string right_key = "Right";
	private static const string left_key = "Left";
	private static const string up_key = "Up";
	private static const string down_key = "Down";
	private static const string return_key = "Return";

	//pressed keys
	private bool alt_l;
	private bool strg_l;
	private bool shift_l;
	private bool super_l;
	private bool up;
	private bool down;
	private bool left;
	private bool right;
	private bool return_;
	
	public BTerminal(BTerm.Item item) {
		this.item = item;
	}

	construct {
		terminal = new Vte.Terminal();
		// auto-exit may become a preference at some point?
		terminal.child_exited += term => { destroy(); };
		terminal.eof += term => { destroy(); };
		terminal.window_title_changed += term => { Gtk.Window toplevel = (Gtk.Window) get_toplevel(); toplevel.set_title( term.window_title ); };
		pack_start( terminal, true, true, 0 );

		terminal.set_scrollback_lines( BTerm.Config.scrollback_lines );
		terminal.set_mouse_autohide( true );
		terminal.set_backspace_binding( TerminalEraseBinding.ASCII_DELETE);
		// work around bug in VTE. FIXME: Clear with upstream
		terminal.set_size(BTerm.Config.terminal_size_width, BTerm.Config.terminal_size_heigth);
		stdout.printf("col count = %ld\n", terminal.row_count);
		terminal.fork_command( (string) 0, (string[]) 0, new string[]{}, Environment.get_variable( "HOME" ), true, true, true );
		terminal.key_press_event.connect(key_press_event_cb);		
		terminal.key_release_event.connect(key_release_event_cb);		
	}

	public void paste() {
		terminal.paste_primary();
	}

	public void paste_command( string command )	{
	   terminal.feed_child( command + "\0", -1 );
	}

	public void set_size(uint count) {
		long y = (long)Math.floor(this.terminal.get_row_count()/(long)count);
		stdout.printf("y = %ld\n", y);
		this.terminal.set_size(this.terminal.get_column_count(), y);
		this.show_all();
	}

	private void exec_command() {
		stdout.printf("alt %s; strg %s; shift %s; return %s\n", this.alt_l ? "true" : "false", this.strg_l ? "true" : "false", this.shift_l ? "true" : "false", this.return_ ? "true" : "false");
		if(this.alt_l && this.shift_l && this.up) {
			this.item.exec_command(BTerm.Exec.move_up);
		} else if(this.alt_l && this.shift_l && this.down) {
			this.item.exec_command(BTerm.Exec.move_down);
		} else if(this.alt_l && this.shift_l && this.left) {
			this.item.exec_command(BTerm.Exec.move_left);
		} else if(this.alt_l && this.shift_l && this.right) {
			this.item.exec_command(BTerm.Exec.move_right);
		} else if(this.alt_l && this.return_) {
			stdout.printf("add new\n");
			this.item.exec_command(BTerm.Exec.add);
		}
	}

	bool key_press_event_cb(Gdk.EventKey button) {
		switch(Gdk.keyval_name(button.keyval)) {
			case alt_l_key:
				this.alt_l = !this.alt_l;
				break;
			case strg_l_key:
				this.strg_l = !this.strg_l;
				break;
			case super_l_key:
				this.super_l = !this.super_l;
				break;
			case shift_l_key:
				this.shift_l = !this.shift_l;
				break;
			case up_key:
				this.up = !this.up;
				break;
			case down_key:
				this.down = !this.down;
				break;
			case left_key:
				this.left = !this.left;
				break;
			case right_key:
				this.right = !this.right;
				break;
			case return_key:
				this.return_ = !this.return_;
				break;
			default:
				break;
		}
		stdout.printf("key pressed %s\n", Gdk.keyval_name(button.keyval));
		this.exec_command();
		return false;
	}
	
	bool key_release_event_cb(Gdk.EventKey button) {
		switch(Gdk.keyval_name(button.keyval)) {
			case alt_l_key:
				this.alt_l = !this.alt_l;
				break;
			case strg_l_key:
				this.strg_l = !this.strg_l;
				break;
			case super_l_key:
				this.super_l = !this.super_l;
				break;
			case shift_l_key:
				this.shift_l = !this.shift_l;
				break;
			case up_key:
				this.up = !this.up;
				break;
			case down_key:
				this.down = !this.down;
				break;
			case left_key:
				this.left = !this.left;
				break;
			case right_key:
				this.right = !this.right;
				break;
			case return_key:
				this.return_ = !this.return_;
				break;
			default:
				break;
		}
		stdout.printf("key released %s\n", Gdk.keyval_name(button.keyval));
		return false;
	}
}
