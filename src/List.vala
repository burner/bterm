using GLib;

public class BTerm.Item {
	public uint id;
	private BTerm.Item next;
	private BTerm.Item prev;

	public Item(uint id_in) {
		this.id = id_in;
		this.next = null;
		this.prev = null;
	}

	public void set_next(BTerm.Item? nn) { this.next = nn; }
	public BTerm.Item get_next() { return this.next; }
	public void set_prev(BTerm.Item? nn) { this.prev = nn; }
	public BTerm.Item get_prev() { return this.prev; }	
}

public class BTerm.List {
	private BTerm.Item root;
	private BTerm.Item tail;

	private BTerm.List next;
	private BTerm.List prev;

	static uint count;

	public uint id;

	public List(uint id_in) {
		this.id = id_in;
		var tmp = new BTerm.Item(this.count++);
		tmp.set_next(null);
		tmp.set_prev(null);
		root = tmp;
		tail = tmp;
	}
	
	public void create_item() {
		int r = GLib.Random.int_range(2,10);
		for(int i = 0; i < r; i++) {
			var tmp = new BTerm.Item(this.count++);
			this.tail.set_next(tmp);
			tmp.set_prev(this.tail);
			this.tail = tmp;
		}
	}

	public bool has(uint id) {
		var tmp = this.root;
		while(tmp != null) {
			if(tmp.id == id) return true;
			tmp = tmp.get_next();
		}
		return false;
	}
	
	public BTerm.Item remove(uint id) {
		BTerm.Item tmp = this.root;
		while(tmp.id != id) {
			tmp = tmp.get_next();
		}
		var n = tmp.get_next();
		var p = tmp.get_prev();
		if(n == null && p == null) { //delete

		} else if(n == null && p != null) { //set tail

		} else if(n != null && p == null) { //set root

		} else { //normal

		}
		return tmp;	
	}

	public void append(BTerm.Item ti) {

	}	

	public void print() {
		var tmp = this.root;
		while(tmp != null) {
			stdout.printf("%u ", tmp.id);
			tmp = tmp.get_next();
		}
		stdout.printf("\n");
	}

	public void set_next(BTerm.List? nn) { this.next = nn; }
	public BTerm.List get_next() { return this.next; }
	public void set_prev(BTerm.List? nn) { this.prev = nn; }
	public BTerm.List get_prev() { return this.prev; }
}

public class BTerm.LList {
	private BTerm.List root;
	private BTerm.List tail;

	uint count;

	public LList() {
		var tmp = new BTerm.List(this.count++);
		tmp.create_item();
		tmp.set_next(null);
		tmp.set_prev(null);
		root = tmp;
		tail = tmp;
	}
	
	public void create_item() {
		var tmp = new BTerm.List(this.count++);
		tmp.create_item();
		this.tail.set_next(tmp);
		tmp.set_prev(this.tail);
		this.tail = tmp;
	}

	public void print() {
		var tmp = this.root;
		while(tmp != null) {
			tmp.print();
			tmp = tmp.get_next();
		}
	}
}

public static int main(string[] args) {
	var t = new BTerm.LList();
	for(int i = 0; i <10; i++) {
		t.create_item();
	}
	t.print();
	return 0;
}
