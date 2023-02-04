import dfl;

// version = DFL_USE_STREAM; // Stream is deprecated.

version(Have_dfl) // For DUB.
{
}
else
{
	pragma(lib, "dfl.lib");
}

class MainForm : Form
{
	private Button _openButton;
	private Button _saveButton;
	private Button _folderButton;
	private Button _fontButton;
	private Button _colorButton;
	private Button _printButton;

	private OpenFileDialog _openFileDialog;
	private SaveFileDialog _saveFileDialog;
	private FolderBrowserDialog _folderDialog;
	private FontDialog _fontDialog;
	private ColorDialog _colorDialog;
	// private PrintDialog _printDialog; // TODO: Not implemented yet.

	private void doOpenFileDialog(Control sender, EventArgs e)
	{
		// Settings
		_openFileDialog.title = "Select to open file";
		_openFileDialog.initialDirectory = ".";
		_openFileDialog.fileName = "*.md"; // Initial file name
		_openFileDialog.filter = "All files(*.*)|*.*|MD file(*.md)|*.md";
		_openFileDialog.filterIndex = 1; // 1 is *.md
		
		_openFileDialog.restoreDirectory = true;
		_openFileDialog.checkFileExists = true;
		_openFileDialog.checkPathExists = true;
		_openFileDialog.dereferenceLinks = true;
		_openFileDialog.multiselect = false; // single select

		_openFileDialog.defaultExt = "md";
		// _openFileDialog.addExtension = true; // TODO: Not implemented yet.

		DialogResult r = _openFileDialog.showDialog();
		if (r == DialogResult.OK)
		{
			version(DFL_USE_STREAM) // Stream is deprecated.
			{
				import undead.stream;
				Stream st = _openFileDialog.openFileStream;
				foreach(char[] line; st)
				{
					msgBox(cast(string)line, _openFileDialog.fileName); break; // Read first line only.
				}
			}
			else
			{
				import std.stdio;
				File file = _openFileDialog.openFile();
				foreach(line; file.byLine())
				{
					msgBox(cast(string)line, _openFileDialog.fileName); break; // Read first line only.
				}
			}
		}
	}

	private void doSaveFileDialog(Control sender, EventArgs e)
	{
		_saveFileDialog.title = "Select to write file";
		_saveFileDialog.fileName = "newfile.txt";
		_saveFileDialog.initialDirectory = r".";
		_saveFileDialog.filter = "TXT file|*.txt|All files(*.*)|*.*";
		_saveFileDialog.filterIndex = 0;
		
		_saveFileDialog.restoreDirectory = true;
		_saveFileDialog.checkFileExists = true;
		_saveFileDialog.checkPathExists = true;
		_saveFileDialog.overwritePrompt = true;
		
		DialogResult r = _saveFileDialog.showDialog();
		if (r == DialogResult.OK)
		{
			// import std.stdio;
			// File file = _saveFileDialog.openFile();
			// file.write("Hello DFL.");
			msgBox(_saveFileDialog.fileName, "Created new file");
		}
	}

	private void doFolderDialog(Control sender, EventArgs e)
	{
		_folderDialog.description = "Select folder";
		_folderDialog.showNewStyleDialog = true;
		_folderDialog.showNewFolderButton = true;
		_folderDialog.showTextBox = true;
		_folderDialog.rootFolder = Environment.SpecialFolder.MY_COMPUTER;
		_folderDialog.selectedPath = Environment.getFolderPath(Environment.SpecialFolder.MY_DOCUMENTS);

		DialogResult r = _folderDialog.showDialog();
		if (r == DialogResult.OK)
		{
			msgBox(_folderDialog.selectedPath, "Selected folder");
		}
	}

	private void doFontDialog(Control sender, EventArgs e)
	{
		_fontDialog.font = new Font("Meiryo UI", 14f);
		_fontDialog.color = Color(255, 0, 0);
		_fontDialog.minSize = 8;
		_fontDialog.maxSize = 20;

		_fontDialog.allowVerticalFonts = false;
		_fontDialog.showEffects = true;
		_fontDialog.fontMustExist = true;
		_fontDialog.fixedPitchOnly = false;
		_fontDialog.allowVectorFonts = true;
		_fontDialog.allowSimulations = true;
		_fontDialog.scriptsOnly = false;

		DialogResult r = _fontDialog.showDialog();
		if (r == DialogResult.OK)
		{
			msgBox(_fontDialog.font.name, "Selected font");
		}
	}

	private void doColorDialog(Control sender, EventArgs e)
	{
		_colorDialog.color = Color(255, 0, 0);
		_colorDialog.allowFullOpen = true;
		_colorDialog.solidColorOnly = false;
		_colorDialog.fullOpen = false;
		_colorDialog.anyColor = true;
		_colorDialog.customColors = [1000, 2000, 3000, 4000];

		DialogResult r = _colorDialog.showDialog();
		if (r == DialogResult.OK)
		{
			auto red = _colorDialog.color.r;
			auto green = _colorDialog.color.g;
			auto blue = _colorDialog.color.b;
			import std.format;
			string mes = format("(R,G,B) = (%d,%d,%d)", red, green, blue);
			msgBox(mes, "Selected color");
		}
	}

	public this()
	{
		this.text = "Common dialogs example";
		this.size = Size(350, 300);

		_openFileDialog = new OpenFileDialog();
		_saveFileDialog = new SaveFileDialog();
		_folderDialog = new FolderBrowserDialog();
		_fontDialog = new FontDialog();
		_colorDialog = new ColorDialog();

		with(_openButton = new Button())
		{
			parent = this;
			text = "Open file";
			location = Point(10, 10);
			size = Size(100, 23);
			click ~= &doOpenFileDialog;
		}
		with(_saveButton = new Button())
		{
			parent = this;
			text = "Save file";
			location = Point(10, 40);
			size = Size(100, 23);
			click ~= &doSaveFileDialog;
		}
		with(_folderButton = new Button())
		{
			parent = this;
			text = "Folder";
			location = Point(10, 70);
			size = Size(100, 23);
			click ~= &doFolderDialog;
		}
		with(_fontButton = new Button())
		{
			parent = this;
			text = "Font";
			location = Point(10, 100);
			size = Size(100, 23);
			click ~= &doFontDialog;
		}
		with(_colorButton = new Button())
		{
			parent = this;
			text = "Color";
			location = Point(10, 130);
			size = Size(100, 23);
			click ~= &doColorDialog;
		}
		// TODO: PrintDialog is not implemented yet.
		with(_printButton = new Button())
		{
			parent = this;
			text = "Print";
			location = Point(10, 160);
			size = Size(100, 23);
			enabled = false;
		}
	}
}

static this()
{
	Application.enableVisualStyles();
}

void main()
{
	Application.run(new MainForm());
}
