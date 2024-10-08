// ---------------------------------------------------------------------------------
//  Noticias bandaancha.eu v2
//
//  v2.8.2.2163
//  Por Jos� Ignacio Legido Barrios (usuario djnacho de bandaancha.eu)
//  Creado para la comunidad de usuarios de bandaancha.eu
//
// C�digo fuente abierto y libre seg�n licencia GPL v3
// https://www.gnu.org/licenses/gpl-3.0.txt
//
// Creada inicialmente en Delphi 10.2 Tokyo
//
// Versi�n actual creada en Delphi 11.2 Alexandria
//
// Feed de noticias descargado directamente de bandaancha.eu para evitar la lentitud
// de actualizaci�n de feedburner.com
//
// 18-08-2023: Aprovechando que hay que actualizar la app para que sea compatible con las nuevas directrices de Play Store
// se procede a incorporar el primer c�digo beta del sistema de notificaciones de la app. A�n est� en desarrollo y s�lo funciona si la app est�
// ejecut�ndose en primer plano.
// 27-08-2023: Se incorpora el c�digo que permite que cuando el usuario pulsa sobre la notificaci�n de la app, se abra directemente el enlace
// de esa noticia, sin tener que pulsar nuevamente sobre el t�tulo o la imagen de la noticia una vez pulsada la notificaci�n.
// 13-09-2023: Se incorpora el c�digo para compartir las noticias desde facebook y X (Twitter) de forma inicial. En pr�ximas revisiones
// se a�adir�n m�s redes sociales.
// 05-04-2024: Se cambia el c�digo para compartir las noticias, utilizando el est�ndar de Android para compartir texto entre aplicaciones,
// de forma que ahora se pueden compartir los enlaces con cualquier aplicaci�n que lo permita en el dispositivo (no s�lo con facebook o
// X(Twitter))
// 31-08-2024: Se cambia el c�digo en el parser XML del feed de bandaancha para poder mostrar las noticias correctamente.
// ---------------------------------------------------------------------------------

unit Unit1;

interface

// Unidades (librer�as) que usa la ventana principal del programa


uses
  FMX.Forms, FMX.ExtCtrls, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent, IdComponent,
  IdSSLOpenSSLHeaders, IdTCPConnection, IdTCPClient, IdHTTP, FMX.Controls,
  FMX.ListBox, FMX.Layouts,  FMX.MultiView, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Effects, FMX.Objects, System.Classes,
  FMX.Types, FMX.WebBrowser, System.Types, System.IOUtils, FMX.Platform,
  FMX.VirtualKeyboard, FMX.Helpers.Android, System.UITypes,
  FMX.DialogService, System.StrUtils, Android.JNI.Toast, FMX.LoadingIndicator,
  FMX.DzHTMLText,system.SysUtils, system.DateUtils, System.Notification,
  System.Permissions, FMX.Dialogs, IdCookieManager, Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Net,Androidapi.JNI.App, Androidapi.Helpers, androidapi.Jni.JavaTypes, FMX.Platform.Android,
  Androidapi.JNI.Webkit, Androidapi.JNI.Os, System.Actions, FMX.ActnList,
  FMX.StdActns, FMX.MediaLibrary.Actions;

type
  TForm1 = class(TForm)             // Ventana principal de la aplicaci�n (Main Activity de Android)
    VertScrollBox1: TVertScrollBox; // Caja de desplazamiento vertical (almacena las tarjetas de las noticias en un �rea desplazable)
    Rectangle1: TRectangle;         // �rea de la tarjeta de noticias 1
    ShadowEffect1: TShadowEffect;   // Efecto de sombra sobre la tarjeta 1
    Label2: TLabel;                 // Texto que muestra autor y fecha del posteo de la noticia 1
    ToolBar1: TToolBar;     // Bot�n de men� de la aplicaci�n (icono zona superior derecha de la pantalla)
    Label21: TLabel;                // T�tulo de la aplicaci�n en la parte superior de aplicaci�n
    Rectangle2: TRectangle;         // �rea de la tarjeta de noticias 2
    ShadowEffect2: TShadowEffect;   // Efecto de sombra sobre la tarjeta 2
    Label3: TLabel;                 // T�tulo de la noticia de la tarjeta 2
    Label4: TLabel;                 // Texto que muestra autor y fecha del posteo de la noticia 2
    Rectangle3: TRectangle;         // �rea de la tarjeta de noticias 3
    ShadowEffect3: TShadowEffect;   // Efecto de sombra sobre la tarjeta 3
    Label5: TLabel;                 // T�tulo de la noticia de la tarjeta 3
    Label6: TLabel;                 // Texto que muestra autor y fecha del posteo de la noticia 3
    Rectangle4: TRectangle;         // �rea de la tarjeta de noticias 4
    ShadowEffect4: TShadowEffect;   // Efecto de sombra sobre la tarjeta 4
    Label7: TLabel;                 // T�tulo de la noticia de la tarjeta 4
    Label8: TLabel;                 // Texto que muestra autor y fecha del posteo de la noticia 4
    Rectangle5: TRectangle;         // �rea de la tarjeta de noticias 5
    ShadowEffect5: TShadowEffect;   // Efecto de sombra sobre la tarjeta 5
    Label9: TLabel;                 // T�tulo de la noticia de la tarjeta 5
    Label10: TLabel;                // Texto que muestra autor y fecha del posteo de la noticia 5
    Rectangle6: TRectangle;         // �rea de la tarjeta de noticias 6
    ShadowEffect6: TShadowEffect;   // Efecto de sombra sobre la tarjeta 6
    Label11: TLabel;                // T�tulo de la noticia de la tarjeta 6
    Label12: TLabel;                // Texto que muestra autor y fecha del posteo de la noticia 6
    Rectangle7: TRectangle;         // �rea de la tarjeta de noticias 7
    ShadowEffect7: TShadowEffect;   // Efecto de sombra sobre la tarjeta 7
    Label13: TLabel;                // T�tulo de la noticia de la tarjeta 7
    Label14: TLabel;                // Texto que muestra autor y fecha del posteo de la noticia 7
    Rectangle8: TRectangle;         // �rea de la tarjeta de noticias 8
    ShadowEffect8: TShadowEffect;   // Efecto de sombra sobre la tarjeta 8
    Label15: TLabel;                // T�tulo de la noticia de la tarjeta 8
    Label16: TLabel;                // Texto que muestra autor y fecha del posteo de la noticia 8
    Rectangle9: TRectangle;         // �rea de la tarjeta de noticias 9
    Label17: TLabel;                // T�tulo de la noticia de la tarjeta 9
    Label18: TLabel;                // Texto que muestra autor y fecha del posteo de la noticia 9
    Rectangle10: TRectangle;        // �rea de la tarjeta de noticias 10
    ShadowEffect10: TShadowEffect;  // Efecto de sombra sobre la tarjeta 10
    Label19: TLabel;                // T�tulo de la noticia de la tarjeta 10
    Label20: TLabel;     // Elemento 5 del men� principal
    WebBrowser1: TWebBrowser;       // Control que muestra las p�ginas web dentro de la aplicaci�n
    ImageControl1: TImageControl;   // Control que guarda una imagen de la pantalla para volver atr�s despues de realizar alguna acci�n
    SpeedButton2: TSpeedButton;     // Bot�n m�ltiple
    SpeedButton3: TSpeedButton;     // Bot�n m�ltiple
    SpeedButton4: TSpeedButton;     // Bot�n m�ltiple
    ShadowEffect9: TShadowEffect;   // Efecto de sombra sobre la tarjeta 9
    IdHTTP1: TIdHTTP;               // Control que permite la descarga de p�ginas web en la aplicaci�n
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL; // Control que permite utilizar el protocolo HTTPS para p�ginas seguras
    FMXLoadingIndicator1: TFMXLoadingIndicator; // Control animado de carga de p�ginas web
    Label1: TLabel;      // Descripci�n de la noticia 10
    Image1: TImage;       // Imagen de la noticia 1
    Image2: TImage;       // Imagen de la noticia 2
    Image3: TImage;       // Imagen de la noticia 3
    Image4: TImage;       // Imagen de la noticia 4
    Image5: TImage;       // Imagen de la noticia 5
    Image6: TImage;       // Imagen de la noticia 6
    Image7: TImage;       // Imagen de la noticia 7
    Image8: TImage;       // Imagen de la noticia 8
    Image9: TImage;       // Imagen de la noticia 9
    Image10: TImage;       // Descripci�n de la aplicaci�n en el men� deslizante de la app
    DzHTMLText2: TDzHTMLText;       // Descripci�n de la noticia 1
    DzHTMLText3: TDzHTMLText;       // Descripci�n de la noticia 2
    DzHTMLText4: TDzHTMLText;       // Descripci�n de la noticia 3
    DzHTMLText5: TDzHTMLText;       // Descripci�n de la noticia 4
    DzHTMLText6: TDzHTMLText;       // Descripci�n de la noticia 5
    DzHTMLText7: TDzHTMLText;       // Descripci�n de la noticia 6
    DzHTMLText8: TDzHTMLText;       // Descripci�n de la noticia 7
    DzHTMLText9: TDzHTMLText;       // Descripci�n de la noticia 8
    DzHTMLText10: TDzHTMLText;      // Descripci�n de la noticia 9
    DzHTMLText11: TDzHTMLText;      // Descripci�n de la noticia 10
    Panel1: TPanel;                 // Panel que encierra la pantalla de aceptaci�n de normas de bandaancha.eu
    ToolBar2: TToolBar;             // Recuadro superior para logo y texto de la pantalla
    ToolBar3: TToolBar;             // Recuadro inferior para los botones de aceptar o cancelar la aceptaci�n de las normas
    Image12: TImage;                // Imagen con el logotipo de la aplicaci�n
    Label23: TLabel;                // Texto en la parte superior de la pantalla de aceptaci�n de las normas
    DzHTMLText12: TDzHTMLText;      // Texto HTML de las normas de bandaancha.eu
    Button1: TButton;               // Bot�n de aceptar las normas de bandaancha.eu
    Button2: TButton;               // Bot�n para cancelar la aceptaci�n de las normas de bandaancha.eu y salir de la aplicaci�n
    NotificationCenter1: TNotificationCenter; // Control que permite mostrar notificaciones a la app
    SpeedButton5: TSpeedButton;               // Bot�n para compartir la noticia n�mero 1
    SpeedButton6: TSpeedButton;               // Bot�n para compartir la noticia n�mero 2
    SpeedButton7: TSpeedButton;               // Bot�n para compartir la noticia n�mero 3
    SpeedButton8: TSpeedButton;               // Bot�n para compartir la noticia n�mero 4
    SpeedButton9: TSpeedButton;               // Bot�n para compartir la noticia n�mero 5
    SpeedButton10: TSpeedButton;              // Bot�n para compartir la noticia n�mero 6
    SpeedButton11: TSpeedButton;              // Bot�n para compartir la noticia n�mero 7
    SpeedButton12: TSpeedButton;              // Bot�n para compartir la noticia n�mero 8
    SpeedButton13: TSpeedButton;              // Bot�n para compartir la noticia n�mero 9
    SpeedButton14: TSpeedButton;              // Bot�n para compartir la noticia n�mero 10

    ActionList1: TActionList;                 // Lista de acciones que puede realizar la aplicaci�n
    ShowShareSheetAction1: TShowShareSheetAction;       // Acci�n de compartir el enlace de la noticia 1
    ShowShareSheetAction2: TShowShareSheetAction;       // Acci�n de compartir el enlace de la noticia 2
    ShowShareSheetAction3: TShowShareSheetAction;       // Acci�n de compartir el enlace de la noticia 3
    ShowShareSheetAction4: TShowShareSheetAction;       // Acci�n de compartir el enlace de la noticia 4
    ShowShareSheetAction5: TShowShareSheetAction;       // Acci�n de compartir el enlace de la noticia 5
    ShowShareSheetAction6: TShowShareSheetAction;       // Acci�n de compartir el enlace de la noticia 6
    ShowShareSheetAction7: TShowShareSheetAction;       // Acci�n de compartir el enlace de la noticia 7
    ShowShareSheetAction8: TShowShareSheetAction;       // Acci�n de compartir el enlace de la noticia 8
    ShowShareSheetAction9: TShowShareSheetAction;       // Acci�n de compartir el enlace de la noticia 9
    ShowShareSheetAction10: TShowShareSheetAction;
    Panel2: TPanel;
    Rectangle11: TRectangle;
    Image11: TImage;
    Label22: TLabel;
    Image13: TImage;
    Label24: TLabel;
    Image14: TImage;
    Label25: TLabel;
    Image15: TImage;
    Label26: TLabel;      // Acci�n de compartir el enlace de la noticia 10
    procedure AbreBandaAncha(Sender: TObject);    // Rutina para abrir la p�gina de bandaancha.eu
    procedure AbreForos(Sender: TObject);         // Rutina para abrir la p�gina de foros de bandaancha.eu
    procedure AbreForoApp(Sender: TObject);       // Rutina para abrir el foro de BASpeed dentro de bandaancha.eu
    procedure AbrePaginaDJNacho(Sender: TObject); // Rutina para abrir la p�gina web personal de djnacho
    procedure Label1Tap(Sender: TObject; const Point: TPointF);           // Rutina para abrir el enlace a la noticia 1 si se pulsa el t�tulo 1
    procedure Label3Tap(Sender: TObject; const Point: TPointF);           // Rutina para abrir el enlace a la noticia 2 si se pulsa el t�tulo 2
    procedure Label5Tap(Sender: TObject; const Point: TPointF);           // Rutina para abrir el enlace a la noticia 3 si se pulsa el t�tulo 3
    procedure Label7Tap(Sender: TObject; const Point: TPointF);           // Rutina para abrir el enlace a la noticia 4 si se pulsa el t�tulo 4
    procedure Label9Tap(Sender: TObject; const Point: TPointF);           // Rutina para abrir el enlace a la noticia 5 si se pulsa el t�tulo 5
    procedure Label11Tap(Sender: TObject; const Point: TPointF);          // Rutina para abrir el enlace a la noticia 6 si se pulsa el t�tulo 6
    procedure Label13Tap(Sender: TObject; const Point: TPointF);          // Rutina para abrir el enlace a la noticia 7 si se pulsa el t�tulo 7
    procedure Label15Tap(Sender: TObject; const Point: TPointF);          // Rutina para abrir el enlace a la noticia 8 si se pulsa el t�tulo 8
    procedure Label17Tap(Sender: TObject; const Point: TPointF);          // Rutina para abrir el enlace a la noticia 9 si se pulsa el t�tulo 9
    procedure Label19Tap(Sender: TObject; const Point: TPointF);          // Rutina para abrir el enlace a la noticia 10 si se pulsa el t�tulo 10
    procedure SpeedButton1Click(Sender: TObject);      // Rutina para mostrar el men� deslizante si se pulsa el bot�n del men�
    procedure MultiView1Hidden(Sender: TObject);       // Rutina que ocurre cuando se oculta el men� deslizante
    procedure SpeedButton2Click(Sender: TObject);      // Rutina para navegar hacia atr�s en las p�ginas web si se pulsa el bot�n Atr�s
    procedure SpeedButton3Click(Sender: TObject);      // Rutina para recargar la p�gina web si se pulsa el bot�n Recargar
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);        // Rutina que vigila las pulsaciones de los dedos en la aplicaci�n (sobre todo para controlar el bot�n Atr�s de Android)
    procedure SpeedButton4Click(Sender: TObject);  // Realiza una recarga de todas las noticias en la p�gina principal de la aplicaci�n si se pulsa el bot�n Recargar en la pantalla principal de la aplicaci�n
    procedure FormActivate(Sender: TObject);       // Rutina que se ejecuta cuando se muestra la ventana de la aplicaci�n
    procedure WebBrowser1DidStartLoad(ASender: TObject);     // Rutina que se ejecuta cuando comienza la carga de la p�gina web
    procedure WebBrowser1DidFinishLoad(ASender: TObject);    // Rutina que se ejecuta cuando finaliza la carga de la p�gina web
    procedure DzHTMLText1LinkClick(Sender: TObject; Link: TDHBaseLink;     // Rutina que se ejecuta al hacer click sobre cualquier enlace dentro de la descripci�n de la aplicaci�n en el men� deslizante
      var Handled: Boolean);
    procedure Button2Click(Sender: TObject);         // Rutina que se ejecuta cuando el usuario pulsa el bot�n de cancelar la aceptaci�n de las normas de uso de bandaancha.eu
    procedure Button1Click(Sender: TObject);         // Rutina que se ejecuta cuando el usuario pulsa el bot�n de aceptar las normas de uso de bandaancha.eu
    procedure FormCreate(Sender: TObject);           // Rutina que se activa cuando se crea el activity de la aplicaci�n y antes de ejecutar nada m�s de la app
    procedure IdHTTP1Redirect(Sender: TObject; var dest: string;
      var NumRedirect: Integer; var Handled: Boolean; var VMethod: string);  // Si hay una redirecci�n HTTP al acceder a bandaancha.eu, el control se hace cargo de esa redirecci�n
    procedure NotificationCenter1ReceiveLocalNotification(Sender: TObject;
      ANotification: TNotification);                              // Rutina que se ejecuta cuando se pulsa sobre la notificaci�n de la app (abre directamente en la app el enlace de esa noticia)

    procedure ShowShareSheetAction1BeforeExecute(Sender: TObject);   // Rutina que se ejecuta justa antes de compartir noticia 1
    procedure ShowShareSheetAction3BeforeExecute(Sender: TObject);   // Rutina que se ejecuta justa antes de compartir noticia 2
    procedure ShowShareSheetAction4BeforeExecute(Sender: TObject);   // Rutina que se ejecuta justa antes de compartir noticia 3
    procedure ShowShareSheetAction5BeforeExecute(Sender: TObject);   // Rutina que se ejecuta justa antes de compartir noticia 4
    procedure ShowShareSheetAction6BeforeExecute(Sender: TObject);   // Rutina que se ejecuta justa antes de compartir noticia 5
    procedure ShowShareSheetAction7BeforeExecute(Sender: TObject);   // Rutina que se ejecuta justa antes de compartir noticia 6
    procedure ShowShareSheetAction8BeforeExecute(Sender: TObject);   // Rutina que se ejecuta justa antes de compartir noticia 7
    procedure ShowShareSheetAction9BeforeExecute(Sender: TObject);   // Rutina que se ejecuta justa antes de compartir noticia 8
    procedure ShowShareSheetAction10BeforeExecute(Sender: TObject);  // Rutina que se ejecuta justa antes de compartir noticia 9
    procedure ShowShareSheetAction2BeforeExecute(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    procedure RellenaCampos;               // Rutina que rellena todos los controles que muestran las noticias (im�genes, t�tulos, descripciones y autor/fecha)
    procedure AbreURL(URL: string);        // Rutina que permite abrir una p�gina web dentro de la aplicaci�n
  end;

var
  Form1: TForm1;           // Control de la ventana principal de la aplicaci�n (Main Activity de Android)

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

var
   enlace: array[1..10] of string;       // Array de cadenas que representan los enlaces en texto de las URL a las noticias
   indicenoticia: Word;

// Rutina para abrir la web de bandaancha.eu en la aplicaci�n

procedure TForm1.AbreBandaAncha(Sender: TObject);
begin
     AbreURL('https://bandaancha.eu');  // Llama a la rutina para abrir la URL en el navegador interno de la aplicaci�n
end;


// Rutina para abrir la p�gina del foro de BASpeed en la aplicaci�n

procedure TForm1.AbreForoApp(Sender: TObject);
begin
     AbreURL('https://bandaancha.eu/foros/comunidad/herramientas/baspeed');    // Llama a la rutina para abrir la URL en el navegador interno de la aplicaci�n
end;


// Rutina para abrir la p�gina de los foros de bandaancha.eu en la aplicaci�n

procedure TForm1.AbreForos(Sender: TObject);
begin
     AbreURL('https://bandaancha.eu/foros');    // Llama a la rutina para abrir la URL en el navegador interno de la aplicaci�n
end;


// Rutina para abrir la p�gina personal de djnacho en la aplicaci�n

procedure TForm1.AbrePaginaDJNacho(Sender: TObject);
begin
     AbreURL('https://baspeed.synology.me/djnacho');    // Llama a la rutina para abrir la URL en el navegador interno de la aplicaci�n
end;


// Rutina para abrir una p�gina web en el navegador interno de la aplicaci�n

procedure TForm1.AbreURL(URL: string);

begin
     VertScrollBox1.Visible:=False;   // Cierra el men� deslizante
     SpeedButton2.Visible:=True;      // Hace visible el bot�n de Atr�s del navegador
     SpeedButton3.Visible:=True;      // Hace visible el bot�n de Recarga del navegador
     SpeedButton4.Visible:=False;     // Hace invisible el bot�n recarga de la aplicaci�n principal
     WebBrowser1.Visible:=True;       // Hace visible el navegador interno
     WebBrowser1.URL:=URL;            // Carga la URL de la p�gina en el navegador
     WebBrowser1.Navigate;            // Inicia la carga de la p�gina web en el navegador interno
end;


// Rutina que se ejecuta cuando el usuario acepta las normas de bandaancha.eu

procedure TForm1.Button1Click(Sender: TObject);

var
   ficheronormas: TStringList;                                     // Memoria con lineas de texto
begin
     Panel1.Visible:=False;                                        // Oculta el panel con las normas de bandaancha.eu
     ficheronormas:=TStringList.Create;                            // Crea la variable con lineas de texto
     ficheronormas.Add('1');                                       // A�ade una linea con la cadena '1'
     ficheronormas.SaveToFile(TPath.GetPublicPath+'/normas.txt');  // Graba el archivo normas.txt con esa linea anterior
     ficheronormas.Free;
     Panel2.Visible:=True;
     IdHTTP1.ConnectTimeout:=5000;            // Tiempo de espera hasta conexi�n con servidor = 5 segundos
     IdHTTP1.ReadTimeout:=5000;               // Tiempo de espera hasta lectura de datos del servidor = 5 segundos
     IdSSLIOHandlerSocketOpenSSL1.ConnectTimeout:=5000;    // Tiempo de espera hasta conexi�n con el servidor (parte SSL) = 5 segundos
     IdSSLIOHandlerSocketOpenSSL1.ReadTimeout:=5000;       // Tiempo de espera hasta lectura de datos del servidor (parte SSL) = 5 segundos
     IdOpenSSLSetLibPath(TPath.GetDocumentsPath);           // Indica donde se encuentra la librer�a instalada para el acceso SSL
     RellenaCampos;                                         // Libera la memoria de la variable de lineas de texto
end;


// Rutina que se ejecuta cuando el usuario cancela las normas de bandaancha.eu

procedure TForm1.Button2Click(Sender: TObject);
begin
     Application.Terminate;           // Termina la aplicaci�n inmediatamente
end;



procedure TForm1.Button3Click(Sender: TObject);
begin
     AbreURL('https://bandaancha.eu');         // Muestra la p�gina principal de bandaancha.eu
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
     AbreURL('https://bandaancha.eu/foros');   // Muestra el �ndice de foros de bandaancha.eu
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
     AbreURL('https://bandaancha.eu/foros/comunidad/herramientas/baspeed');   // Muestra el foro de BASpeed dentro de bandaancha.eu
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
     AbreURL('https://baspeed.synology.me/djnacho');                          // Muestra mi p�gina personal
end;

// Rutina para abrir un enlace presente en la descripci�n HTML de la aplicaci�n (localizada en el men� deslizante)

procedure TForm1.DzHTMLText1LinkClick(Sender: TObject; Link: TDHBaseLink;
  var Handled: Boolean);
begin
     WebBrowser1.Visible:=True;               // Hace visible el navegador interno de la aplicaci�n
     AbreURL(Link.LinkRef.Target);            // Abre la URL presente en el link HTML de la descripci�n
end;

// Rutina que se ejecuta al hacerse visible la ventana principal de la aplicaci�n

procedure TForm1.FormActivate(Sender: TObject);

var
   ficheronormas: TStringList;

begin
     Button1.Width:=(Screen.Width/2)-20;                                          // Ajusta ancho del bot�n de aceptaci�n de normas
     Button2.Width:=Button1.Width;                                                // Ajusta el ancho del segundo bot�n
     ficheronormas:=TStringList.Create;                                           // Crea y prepara la variable de lineas de texto
     try
        ficheronormas.LoadFromFile(TPath.GetPublicPath+'/normas.txt');            // Intenta cargar el fichero de texto con la cadena '1'
        Panel1.Visible:=False;                                                    // Si est� oculta el panel de aceptaci�n de normas y sigue la ejecuci�n
        ficheronormas.Free;
        Panel2.Visible:=True;
        IdOpenSSLSetLibPath(TPath.GetDocumentsPath);           // Indica donde se encuentra la librer�a instalada para el acceso SSL                                                      // Libera la memoria de la variable de lineas de texto
        IdHTTP1.ConnectTimeout:=10000;            // Tiempo de espera hasta conexi�n con servidor = 5 segundos
        IdHTTP1.ReadTimeout:=10000;               // Tiempo de espera hasta lectura de datos del servidor = 5 segundos
        IdSSLIOHandlerSocketOpenSSL1.ConnectTimeout:=10000;    // Tiempo de espera hasta conexi�n con el servidor (parte SSL) = 5 segundos
        IdSSLIOHandlerSocketOpenSSL1.ReadTimeout:=10000;       // Tiempo de espera hasta lectura de datos del servidor (parte SSL) = 5 segundos
        RellenaCampos;                                         // Llama a la rutina que rellena todos los datos de las noticias en la pantalla principal
     except                                                  // Si no existe el fichero de texto, el panel de aceptaci�n de normas se hace visible
           ficheronormas.Free;                               // Libera la memoria de la variable de lineas de texto
     end;
end;

procedure TForm1.FormCreate(Sender: TObject);

begin
     Button1.Width:=(Screen.Width/2)-20;
     Button2.Width:=Button1.Width;

     //
     // Cambio en el c�digo debido a los cambios que se han producido en las notificaciones en Android 13.
     //

     {$IFDEF ANDROID}
     if NotificationCenter1.AuthorizationStatus <> TAuthorizationStatus.Authorized then begin
        NotificationCenter1.RequestPermission;
     end;

     if PermissionsService.IsPermissionGranted('android.permission.POST_NOTIFICATIONS') <> True then begin
        PermissionsService.RequestPermissions(['android.permission.POST_NOTIFICATIONS'],
        procedure(const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray)
        begin
          if (AGrantResults[0] <> TPermissionStatus.Granted) and (TOSVersion.Check(13)=True) then
            ShowMessage('Por favor activa las notificaciones de esta app para recibir notificaciones de noticias nuevas.');
        end
      );
    end;
    WebBrowser1.EnableCaching:=False;     // Se desactiva el cach� a nivel de ejecuci�n para que siempre los �ltimos cambios en la p�gina
                                          // pase lo que pase a nivel de dise�o (aviso de Vukits en el foro BASpeed de bandaancha.eu)
  {$ENDIF}
end;

// Rutina que permite reconocer la pulsaci�n de la tecla Atr�s de Android y actuar en consecuencia en la aplicaci�n

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  if (Key = vkHardwareBack) then // Si se pulsa la tecla Atr�s de Android (c�digo VkHardwareBack)
  begin
    if (ImageControl1.Visible=True) then    // Si est� visible el control que permite una copia de la pantalla
       begin
            ImageControl1.Visible:=False;   // Oculta el control que permite la copia de pantalla
            WebBrowser1.Visible:=True;      // Hace visible el navegador interno web de la aplicaci�n
            Key:=0;                         // Retorna a la app el c�digo 0 para que la app pueda seguir explorando pulsaciones de teclas
       end
    else
        if (WebBrowser1.Visible=True) then     // Si est� visible el navegador web interno de la aplicaci�n
           begin
                WebBrowser1.Visible:=False;    // Oculta el navegador web interno
                SpeedButton2.Visible:=False;   // Oculta bot�n de Retrocecer en el navegador web interno
                SpeedButton3.Visible:=False;   // Oculta bot�n de Recargar en el navegador web interno
                SpeedButton4.Visible:=True;    // Hace visible el bot�n de recargar todas las noticias en la pantalla principal de la aplicaci�n
                VertScrollBox1.Visible:=True;  // Hace visible el control de desplazamiento vertical
                ImageControl1.Visible:=False;  // Oculta el control que permite la copia de pantalla
                Key:=0;                        // Retorna a la app el c�digo 0 para que la app pueda seguir explorando pulsaciones de teclas
           end
        else
            begin
                 // Si se pulsa la tecla Atr�s de Android en la pantalla principal de la aplicaci�n
                 // Muestra cuadro de di�logo para seleccionar si se quiere salir de la aplicaci�n
                 TDialogService.MessageDialog('�Desea realmente salir de Noticias bandaancha.eu?',TMsgDlgType.mtWarning,
                 [TMsgDlgBtn.mbCancel,TMsgDlgBtn.mbOK],TMsgDlgBtn.mbOK,0, procedure (const AResult: TModalResult)
                 begin
                      case AResult of
                           mrOk:     Application.Terminate; // Si se selecciona OK, se sale directamente de la aplicaci�n
                           mrCancel: ;                      // Si se selecciona Cancel, se vuelve a la aplicaci�n sin hacer nada
                      end;
                 end);
                 Key:=0;
            end;
  end;

end;


// Rutina que se ejecuta cuando hay una redirecci�n HTTP al acceder a cualquier URL de internet

procedure TForm1.IdHTTP1Redirect(Sender: TObject; var dest: string;
  var NumRedirect: Integer; var Handled: Boolean; var VMethod: string);
begin
     Handled:=True;         // El control se hace cargo de la redirecci�n apuntando a la nueva URL
end;

// Rutina que muestra la noticia n�mero 6 si se pulsa el t�tulo / imagen de la noticia

procedure TForm1.Label11Tap(Sender: TObject; const Point: TPointF);
begin
     AbreURL(enlace[6]);            // Abre en el navegador interno la p�gina web que corresponde a la noticia n�6 de bandaancha.eu
end;


// Rutina que muestra la noticia n�mero 7 si se pulsa el t�tulo / imagen de la noticia

procedure TForm1.Label13Tap(Sender: TObject; const Point: TPointF);
begin
     AbreURL(enlace[7]);            // Abre en el navegador interno la p�gina web que corresponde a la noticia n�7 de bandaancha.eu
end;


// Rutina que muestra la noticia n�mero 8 si se pulsa el t�tulo / imagen de la noticia

procedure TForm1.Label15Tap(Sender: TObject; const Point: TPointF);
begin
     AbreURL(enlace[8]);            // Abre en el navegador interno la p�gina web que corresponde a la noticia n�8 de bandaancha.eu
end;


// Rutina que muestra la noticia n�mero 9 si se pulsa el t�tulo / imagen de la noticia

procedure TForm1.Label17Tap(Sender: TObject; const Point: TPointF);
begin
     AbreURL(enlace[9]);            // Abre en el navegador interno la p�gina web que corresponde a la noticia n�9 de bandaancha.eu
end;


// Rutina que muestra la noticia n�mero 10 si se pulsa el t�tulo / imagen de la noticia

procedure TForm1.Label19Tap(Sender: TObject; const Point: TPointF);
begin
     AbreURL(enlace[10]);           // Abre en el navegador interno la p�gina web que corresponde a la noticia n�10 de bandaancha.eu
end;


// Rutina que muestra la noticia n�mero 1 si se pulsa el t�tulo / imagen de la noticia

procedure TForm1.Label1Tap(Sender: TObject; const Point: TPointF);
begin
     AbreURL(enlace[1]);           // Abre en el navegador interno la p�gina web que corresponde a la noticia n�1 de bandaancha.eu
end;


// Rutina que muestra la noticia n�mero 2 si se pulsa el t�tulo / imagen de la noticia

procedure TForm1.Label3Tap(Sender: TObject; const Point: TPointF);
begin
     AbreURL(enlace[2]);           // Abre en el navegador interno la p�gina web que corresponde a la noticia n�2 de bandaancha.eu
end;


// Rutina que muestra la noticia n�mero 3 si se pulsa el t�tulo / imagen de la noticia

procedure TForm1.Label5Tap(Sender: TObject; const Point: TPointF);
begin
     AbreURL(enlace[3]);           // Abre en el navegador interno la p�gina web que corresponde a la noticia n�3 de bandaancha.eu
end;


// Rutina que muestra la noticia n�mero 4 si se pulsa el t�tulo / imagen de la noticia

procedure TForm1.Label7Tap(Sender: TObject; const Point: TPointF);
begin
     AbreURL(enlace[4]);           // Abre en el navegador interno la p�gina web que corresponde a la noticia n�4 de bandaancha.eu
end;


// Rutina que muestra la noticia n�mero 5 si se pulsa el t�tulo / imagen de la noticia

procedure TForm1.Label9Tap(Sender: TObject; const Point: TPointF);
begin
     AbreURL(enlace[5]);           // Abre en el navegador interno la p�gina web que corresponde a la noticia n�5 de bandaancha.eu
end;


// Rutina que ocurre cuando se ha ocultado el men� deslizante

procedure TForm1.MultiView1Hidden(Sender: TObject);
begin
     if (ImageControl1.Visible=True) then  // Si el control de copia de pantalla est� visible
        begin
             ImageControl1.Visible:=False; // Oculta control de copia de pantalla
             WebBrowser1.Visible:=True;    // Hace visible el navegador web interno de la aplicaci�n
        end;
end;

procedure TForm1.NotificationCenter1ReceiveLocalNotification(Sender: TObject;
  ANotification: TNotification);
begin

     //
     // C�digo que permite abrir directamente el enlace de la noticia que se muestra como notificaci�n en el dispositivo
     //

     // Si la notificacion es Noticias_ba (notificaci�n de la app)
     if (ANotification.Name='Noticias_ba') then
        // Abre primer enlace de las noticias (la app siempre muestra como notificaci�n la primera noticia m�s nueva)
        AbreURL(enlace[1]);
end;

// Rutina que parsea el c�digo XML de feedburner.com para obtener todos los datos necesarios de las noticias de bandancha.eu

procedure TForm1.RellenaCampos;

var
   xml: string;                 // Variable que guarda todo el c�digo XML que devuelve feedburner.com
   cadena, subcadena: string;   // Cadenas de caracteres para operaciones varias
   titulo: string;              // Cadena de caracteres que contiene el t�tulo de una noticia
   contenido: string;           // Cadena de caracteres que contiene el contenido de una noticia
   autor: string;               // Cadena de caracteres que contiene el autor de la noticia
   fechahora: string;           // Cadena de caracteres que contiene la fecha y hora de publicaci�n de la noticia
   fecha,hora: string;          // Cadenas de caracteres temporales para guardar fecha y hora
   cadenaenlace: string;        // Cadena de caracteres que guarda el enlace a la p�gina en bandaancha.eu de la noticia
   posicion: Integer;           // N�mero que indica una posici�n inicial en una cadena de caracteres
   posicion2: Integer;          // N�mero que indica una posici�n final en una cadena de caracteres
   next: Integer;               // N�mero que indica la siguiente posici�n de una subcadena de caracteres dentro de otra cadena de caracteres
   indice: integer;             // N�mero de noticia
   urlimagen: string;           // Cadena de caracteres que guarda la URL de la noticia
   memoria: TMemoryStream;      // Zona de memoria para guardar una imagen
   descripcion: string;         // Cadena de caracteres que contiene una descripci�n de la noticia (dentro del contenido desde el primer <p> hasta el primer </p>)
   dia, mes, anio: string;
   horatemp: TDateTime;
   intentosdescargaarchivo: Word;
   Notificacion: TNotification;
   cadenatitulo: TStringList;

begin
     DzHTMLText2.Lines.Clear;   // Limpia la descripci�n de la noticia 1
     DzHTMLText3.Lines.Clear;   // Limpia la descripci�n de la noticia 2
     DzHTMLText4.Lines.Clear;   // Limpia la descripci�n de la noticia 3
     DzHTMLText5.Lines.Clear;   // Limpia la descripci�n de la noticia 4
     DzHTMLText6.Lines.Clear;   // Limpia la descripci�n de la noticia 5
     DzHTMLText7.Lines.Clear;   // Limpia la descripci�n de la noticia 6
     DzHTMLText8.Lines.Clear;   // Limpia la descripci�n de la noticia 7
     DzHTMLText9.Lines.Clear;   // Limpia la descripci�n de la noticia 8
     DzHTMLText10.Lines.Clear;  // Limpia la descripci�n de la noticia 9
     DzHTMLText11.Lines.Clear;  // Limpia la descripci�n de la noticia 10
     SpeedButton4.Visible:=False;         // Desactiva bot�n de recargar noticias en pantalla principal
     FMXLoadingIndicator1.Visible:=True;  // Hace visible el indicador de carga de p�gina
     FMXLoadingIndicator1.Active:=True;   // Hace que se inicie la animaci�n del indicador de carga de p�gina
     TThread.CreateAnonymousThread(procedure // Inicia hilo as�ncrono con la aplicaci�n para cargar los datos de las noticias
     begin
     // Repite el siguiente trozo de c�digo en caso de error de transferencia hasta que se obtenga un c�digo ok de transferencia (entre 200 y 299)
     // Se hace para obtener el feed XML de feedburner

     // Pone el contador de intentos de descargas a 0

     intentosdescargaarchivo:=0;
     repeat
           try
              xml:=IdHTTP1.Get('https://bandaancha.eu/portada.atom');      // Coge el feed directamente de bandaancha.eu sin pasar por feedburner.com (as� se actualizan las noticias en el momento de publicarlas)
           except
                 ;
           end;
           inc(intentosdescargaarchivo,1);
     until ((IdHTTP1.ResponseCode>=200) and (IdHTTP1.ResponseCode<=299)) or (intentosdescargaarchivo>3);

     // Si se consigue descargar el archivo correctamente en menos de tres intentos

     if (intentosdescargaarchivo<3) then
        begin
             indice:=1;                                                                           // Inicia el �ndice de noticias a 1
             repeat                                                                               // Bucle
                   posicion:=Pos('<entry>',xml,1);                                                 // Busca dentro de XML la cadena <entry> (inicio de noticia)
                   if (posicion<>-1) then                                                          // Mientras lo encuentre (posici�n<>-1)
                      begin
                           posicion2:=Pos('</entry>',xml,1)+length('</entry>');                   // Busca dentro de XML la cadena </entry> (fin de noticia)
                           next:=posicion2;                                                       // Carga la posici�n en next
                           subcadena:=Copy(xml,posicion+8,posicion2-posicion-8);                  // Rellena subcadena con la cadena que hay dentro de <entry> y </entry>
                           posicion:=pos('<title>',subcadena,1);                                  // Busca dentro de subcadena la cadena <title> (inicio t�tulo de la noticia)
                           posicion2:=pos('</title>',subcadena,1);                                // Busca dentro de subcadena la cadena </title> (fin de t�tulo de t�tulo)
                           titulo:=copy(subcadena,posicion+7,posicion2-posicion-7);               // Rellena t�tulo con la cadena que hay entre <title> y </title>
                           posicion:=pos('<name>',subcadena,1);                                   // Busca dentro de subcadena la cadena <name> (inicio de autor)
                           posicion2:=pos('</name>',subcadena,1);                                 // Busca dentro de subcadena la cadena </name> (fin de autor)
                           autor:=copy(subcadena,posicion+6,posicion2-posicion-6);                // Rellena autor con la cadena que hay entre <name> y </name>
                           posicion:=pos('<content type="html">',subcadena,1);                    // Busca dentro de subcadena la cadena <content type="html"> (inicio de contenido)
                           posicion2:=pos('</content>',subcadena,1);                              // Busca dentro de subcadena la cadena </content> (fin de contenido)
                           contenido:=copy(subcadena,posicion+20,posicion2-posicion-20);          // Rellena contenido con la que cadena que hay entre <content type="html"> y </content>

                           posicion:=Pos('img class=cn src=',contenido,1);                        // Busca dentro de contenido la cadena img class=cn src= (inicio de imagen)
                           if  (posicion<>0) then                                                 // Si la cadena existe (posici�n<>0)
                               begin
                                    // Arreglado el fallo de la carga de las im�genes aqu�.
                                    // En vez de posicion+17 se le indicaba posicion+21, por lo que el puntero calculaba mal la posicion de
                                    // donde coger la imagen. Ahora queda solucionado. Aparte se a�ade c�digo por si hubiera alg�n fallo al
                                    // cargar la imagen, entonces carga la imagen por defecto.
                                    posicion2:=Pos(' ',contenido,posicion+17);                     // Busca dentro de posicion el primer espacio
                                    urlimagen:=Copy(contenido,posicion+17,posicion2-posicion-17);  // Copia la URL de la imagen (toda la cadena desde el final de img class=cn src= hasta el primer espacio)
                                    memoria:=TMemoryStream.Create;                                 // Crea la zona de memoria para la imagen
                                    // Repite el siguiente trozo de c�digo en caso de error de transferencia hasta que se obtenga un c�digo ok de transferencia (entre 200 y 299)
                                    // Se hace para obtener la imagen de la noticia de bandaancha.eu
                                    intentosdescargaarchivo:=0;
                                    repeat

                                          try
                                             memoria.Seek(0,0);                                     // Intenta descargar la imagen tres veces como m�ximo
                                             IdHTTP1.Get(urlimagen,memoria);                        // Obtiene la imagen de la URL y la carga en la zona de memoria
                                          except
                                                ;
                                          end;
                                          Inc(intentosdescargaarchivo,1);
                                    until ((IdHTTP1.ResponseCode>=200) and (IdHTTP1.ResponseCode<=299)) or (intentosdescargaarchivo>3);
                                   if (intentosdescargaarchivo<=3) then
                                      begin
                                           TThread.Synchronize(nil,procedure                              // Inicia otro hilo as�ncrono para cargar la imagen
                                           begin
                                                Form1.BeginUpdate;                                             // Prepara la ventana para actualizar
                                                case indice of                                                 // Dependiendo del valor de la variable indice
                                                     1      : begin
                                                                   Image1.Bitmap.LoadFromStream(memoria);      // Carga en la imagen 1
                                                              end;
                                                     2      : begin
                                                                   Image2.Bitmap.LoadFromStream(memoria);      // Carga en la imagen 2
                                                              end;
                                                     3      : begin
                                                                   Image3.Bitmap.LoadFromStream(memoria);      // Carga en la imagen 3
                                                              end;
                                                     4      : begin
                                                                   Image4.Bitmap.LoadFromStream(memoria);      // Carga en la imagen 4
                                                              end;
                                                     5      : begin
                                                                   Image5.Bitmap.LoadFromStream(memoria);      // Carga en la imagen 5
                                                              end;
                                                     6      : begin
                                                                   Image6.Bitmap.LoadFromStream(memoria);      // Carga en la imagen 6
                                                              end;
                                                     7      : begin
                                                                   Image7.Bitmap.LoadFromStream(memoria);      // Carga en la imagen 7
                                                              end;
                                                     8      : begin
                                                                   Image8.Bitmap.LoadFromStream(memoria);      // Carga en la imagen 8
                                                              end;
                                                     9      : begin
                                                                   Image9.Bitmap.LoadFromStream(memoria);      // Carga en la imagen 9
                                                              end;
                                                     10     : begin
                                                               Image10.Bitmap.LoadFromStream(memoria);     // Carga en la imagen 10
                                                              end;
                                                end;
                                                Form1.EndUpdate;                                               // Fin de actualizaci�n de ventana principal
                                           end);
                                           memoria.Free;
                                     end
                                   else
                                        // Si falla la descarga de la imagen, entonces usa la imagen por defecto de la app
                                        begin
                                             case indice of                                                     // Dependiendo del valor de la variable indice
                                                  1      : begin
                                                                Image1.Bitmap.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,'ba.png'));    // Imagen por defecto 1
                                                           end;
                                                  2      : begin
                                                                Image2.Bitmap.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,'ba.png'));    // Imagen por defecto 2
                                                           end;
                                                  3      : begin
                                                                Image3.Bitmap.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,'ba.png'));    // Imagen por defecto 3
                                                           end;
                                                  4      : begin
                                                                Image4.Bitmap.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,'ba.png'));    // Imagen por defecto 4
                                                           end;
                                                  5      : begin
                                                                Image5.Bitmap.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,'ba.png'));    // Imagen por defecto 5
                                                           end;
                                                  6      : begin
                                                                Image6.Bitmap.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,'ba.png'));    // Imagen por defecto 6
                                                           end;
                                                  7      : begin
                                                                Image7.Bitmap.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,'ba.png'));    // Imagen por defecto 7
                                                           end;
                                                  8      : begin
                                                                Image8.Bitmap.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,'ba.png'));    // Imagen por defecto 8
                                                           end;
                                                  9      : begin
                                                                Image9.Bitmap.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,'ba.png'));    // Imagen por defecto 9
                                                           end;
                                                  10     : begin
                                                                Image10.Bitmap.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,'ba.png'));   // Imagen por defecto 10
                                                           end;
                                             end;
                                        end;                                                                                                                                // Libera la zona de memoria para imagen
                               end                                                                 // Si no existe la cadena img class=cn src=
                           else
                               TThread.Synchronize(nil,procedure                                  // Inicia hilo as�ncrono para cargar imagen por defecto
                               begin
                                    case indice of                                                     // Dependiendo del valor de la variable indice
                                         1      : begin
                                                       Image1.Bitmap.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,'ba.png'));    // Imagen por defecto 1
                                                  end;
                                         2      : begin
                                                       Image2.Bitmap.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,'ba.png'));    // Imagen por defecto 2
                                                  end;
                                         3      : begin
                                                       Image3.Bitmap.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,'ba.png'));    // Imagen por defecto 3
                                                  end;
                                         4      : begin
                                                       Image4.Bitmap.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,'ba.png'));    // Imagen por defecto 4
                                                  end;
                                         5      : begin
                                                       Image5.Bitmap.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,'ba.png'));    // Imagen por defecto 5
                                                  end;
                                         6      : begin
                                                       Image6.Bitmap.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,'ba.png'));    // Imagen por defecto 6
                                                  end;
                                         7      : begin
                                                       Image7.Bitmap.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,'ba.png'));    // Imagen por defecto 7
                                                  end;
                                         8      : begin
                                                       Image8.Bitmap.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,'ba.png'));    // Imagen por defecto 8
                                                  end;
                                         9      : begin
                                                       Image9.Bitmap.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,'ba.png'));    // Imagen por defecto 9
                                                  end;
                                         10     : begin
                                                       Image10.Bitmap.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath,'ba.png'));   // Imagen por defecto 10
                                                  end;
                                    end;
                               end);

                           posicion:=Pos('&lt;p&gt;',contenido,1);                                           // Busca en contenido &lt;p&gt (<p>)
                           posicion2:=Length(contenido);                                                     // Posicion2 = longitud de contenido
                           descripcion:=Copy(contenido,posicion,posicion2-posicion);                         // Rellena descripcion desde el primer <p> hasta el final
                           cadena:=ReplaceStr(descripcion,'&lt;','<');                                       // Rellena cadena con toda la cadena de descripcion desde el final de <p
                           descripcion:=Copy(cadena,1,Length(cadena));                                       // Reemplaza &lt por <
                           cadena:=ReplaceStr(descripcion,'&gt;','>');                                       // Reemplaza &gt por >
                           descripcion:=Copy(cadena,1,Length(cadena));                                       // Rellena descrici�n con la nueva cadena con los caracteres con el inicio y fin de p�rrado est�ndar <p> y </p>
                           posicion:=Pos('<p>',descripcion,1);                                               // Busca dentro de descripcion el <p> (inicio de p�rrafo)
                           posicion2:=Pos('</p>',descripcion,posicion);                                      // Busca dentro de descripcion el </p> (fin de p�rrafo)
                           cadena:=Copy(descripcion,posicion+3,posicion2-posicion-3);                        // Rellena cadena con todos los caracteres entre <p> y </p>

                           // Nueva parte donde se cogen los enlaces dentro de la descripci�n y se ajustan al estilo del componente DzHTMLText

                           cadena:=ReplaceStr(cadena,'<a href=','<a:');  // Se reemplaza el <a href=" con <a: que es el tag de enlace de DzHTMLText


                           TThread.Synchronize(nil,procedure                                                 // Inicia hilo as�ncrono para mostrar la descripci�n de la noticia
                           begin
                                case indice of                                                                    // Dependiendo del valor de indice
                                     1      : DzHTMLText2.Lines.Add(cadena);                                      // Rellena descripci�n noticia 1
                                     2      : DzHTMLText3.Lines.Add(cadena);                                      // Rellena descripci�n noticia 2
                                     3      : DzHTMLText4.Lines.Add(cadena);                                      // Rellena descripci�n noticia 3
                                     4      : DzHTMLText5.Lines.Add(cadena);                                      // Rellena descripci�n noticia 4
                                     5      : DzHTMLText6.Lines.Add(cadena);                                      // Rellena descripci�n noticia 5
                                     6      : DzHTMLText7.Lines.Add(cadena);                                      // Rellena descripci�n noticia 6
                                     7      : DzHTMLText8.Lines.Add(cadena);                                      // Rellena descripci�n noticia 7
                                     8      : DzHTMLText9.Lines.Add(cadena);                                      // Rellena descripci�n noticia 8
                                     9      : DzHTMLText10.Lines.Add(cadena);                                     // Rellena descripci�n noticia 9
                                     10     : DzHTMLText11.Lines.Add(cadena);                                     // Rellena descripci�n noticia 10
                                end;
                           end);

                           posicion:=pos('<updated>',subcadena,1);                                           // Busca dentro de subcadena la cadena <updated> (fecha y hora de publicaci�n)
                           posicion2:=pos('</updated>',subcadena,1);                                         // Busca dentro de subcadena la cadena </updated> (fin de fecha y hora de publicaci�n)
                           fechahora:=copy(subcadena,posicion+9,posicion2-posicion-9);                       // Copia la cadena entre <updated> y </updated> en la variable fechahora
                           fecha:=copy(fechahora,1,16);

                           // Nueva rutina para cambiar el mes del ingl�s al castellano

                   anio:=Copy(fecha,1,4);       // Toma el a�o de la publicaci�n
                   mes:=Copy(fecha,6,2);        // Toma el mes de la publicaci�n
                   dia:=Copy(fecha,9,2);       // Toma el d�a de la publicaci�n
                   hora:=Copy(fecha,12,16);    // toma la hora de publicaci�n
                   horatemp:=StrToTime(hora);  // Cambia la hora de cadena de caracteres a valor de tiempo
                   horatemp:=IncHour(horatemp,2); // Incrementa las horas en 2 (el feed pone la hora en horario GMT, al cual hay que sumarle 2 horas para que coincida con la hora espa�ola)
                   if (HourOf(horatemp)<10) and (MinuteOf(horatemp)<10) then
                      hora:='0'+IntToStr(HourOf(horatemp))+':0'+IntToStr(MinuteOf(horatemp)) // La nueva hora (GMT+2) se pone de nuevo en formato de cadena de caracteres (con un cero delante de las horas si las horas y los minutos son < 10)
                   else
                       if (HourOf(horatemp)<10) then
                          hora:='0'+IntToStr(HourOf(horatemp))+':'+IntToStr(MinuteOf(horatemp)) // La nueva hora (GMT+2) se pone de nuevo en formato de cadena de caracteres (con un cero delante de los minutos si las horas son < 10)
                          else
                              if (MinuteOf(horatemp)<10) then
                                 hora:=IntToStr(HourOf(horatemp))+':0'+IntToStr(MinuteOf(horatemp))    // La nueva hora (GMT+2) se pone de nuevo en formato de cadena de caracteres (con un cero delante de los minutos si los minutos son < 10)
                              else
                                  hora:=IntToStr(HourOf(horatemp))+':'+IntToStr(MinuteOf(horatemp));  // La nueva hora (GMT+2) se pone de nuevo en formato de cadena de caracteres
                   fecha:=dia+'-'+mes+'-'+anio+' ('+hora+')'; // Rellena la variable fecha con todos los valores (fecha y hora de publicaci�n)

                   posicion:=pos('<link rel="alternate" type="text/html" href="',subcadena,1);       // Busca dentro de subcadena la cadena <link rel="alternate" type "text/html" href=" (inicio de enlace a la noticia)
                   posicion2:=pos('"/>',subcadena,posicion);                                         // Busca dentro de subcadena la cadena </link> (fin de enlace a la noticia)
                   cadenaenlace:=copy(subcadena,posicion+length('<link rel="alternate" type="text/html" href="'),posicion2-posicion-length('<link rel="alternate" type="text/html" href="'));     // Copia el enlace URL a la noticia a la variable cadenaenlace
                   enlace[indice]:=cadenaenlace;                        // Rellena el array de enlaces a noticias en el indice indicado con la cadena cadenaenlace
                   xml:=copy(xml,next,length(xml)-next);                                              // Pone el puntero de XML a la siguiente zona de noticias
                   TThread.Synchronize(nil,procedure                                                 // Inicia hilo as�ncrono para mostrar t�tulo, autor, fecha y hora de publicaci�n de la noticia
                   begin
                   case indice of                                                                    // Dependiendo del valor de la variable indice
                        1      : begin
                                      Label1.Text:=titulo;                                           // Rellena t�tulo noticia 1
                                      Label2.Text:='Autor: '+autor+', '+fecha;        // Rellena autor, fecha y hora noticia 1
                                 end;
                        2      : begin
                                      Label3.Text:=titulo;                                           // Rellena t�tulo noticia 2
                                      Label4.Text:='Autor: '+autor+', '+fecha;        // Rellena autor, fecha y hora noticia 2
                                 end;
                        3      : begin
                                      Label5.Text:=titulo;                                           // Rellena t�tulo noticia 3
                                      Label6.Text:='Autor: '+autor+', '+fecha;        // Rellena autor, fecha y hora noticia 3
                                 end;
                        4      : begin
                                      Label7.Text:=titulo;                                           // Rellena t�tulo noticia 4
                                      Label8.Text:='Autor: '+autor+', '+fecha;        // Rellena autor, fecha y hora noticia 4
                                 end;
                        5      : begin
                                      Label9.Text:=titulo;                                           // Rellena t�tulo noticia 5
                                      Label10.Text:='Autor: '+autor+', '+fecha;      // Rellena autor, fecha y hora noticia 5
                                 end;
                        6      : begin
                                      Label11.Text:=titulo;                                          // Rellena t�tulo noticia 6
                                      Label12.Text:='Autor: '+autor+', '+fecha;      // Rellena autor, fecha y hora noticia 6
                                 end;
                        7      : begin
                                      Label13.Text:=titulo;                                          // Rellena t�tulo noticia 7
                                      Label14.Text:='Autor: '+autor+', '+fecha;       // Rellena autor, fecha y hora noticia 7
                                 end;
                        8      : begin
                                      Label15.Text:=titulo;                                          // Rellena t�tulo noticia 8
                                      Label16.Text:='Autor: '+autor+', '+fecha;       // Rellena autor, fecha y hora noticia 8
                                 end;
                        9      : begin
                                      Label17.Text:=titulo;                                          // Rellena t�tulo noticia 9
                                      Label18.Text:='Autor: '+autor+', '+fecha;       // Rellena autor, fecha y hora noticia 9
                                 end;
                        10     : begin
                                      Label19.Text:=titulo;                                          // Rellena t�tulo noticia 10
                                      Label20.Text:='Autor: '+autor+', '+fecha;       // Rellena autor, fecha y hora noticia 10
                                 end;

                   end;
                   end);
              end;
          Inc(indice,1);         // Incrementa en 1 el valor de indice (siguiente noticia)
     until (indice>10);          // Repite bucle 10 veces (presenta las 10 primeras noticias de bandaancha.eu)
     TThread.Synchronize(nil,procedure                    // Inicia hilo as�ncrono para presentar la pantalla inicial de la app con sus elementos principales
     begin
          VertScrollBox1.ViewportPosition:=PointF(0,0);   // Sube la caja vertical de desplazamiento hasta el inicio (muestra primera noticia)
          SpeedButton4.Visible:=True;                     // Hace visible el bot�n de recargar noticias
          FMXLoadingIndicator1.Active:=False;             // Para la animaci�n del indicar de carga de p�ginas
          FMXLoadingIndicator1.Visible:=False;            // Hace invisible el indicador de carga de p�ginas
     end);

      //
      // Nuevo c�digo para ver si hay que presentar notificaciones de noticias nuevas
      // Primero comprueba si existe el archivo newnotice.txt en el dispositivo. Si no existe muestra la notificaci�n de la primera noticia.
      // Si existe comprueba que el t�tulo extraido del XML del feed y el texto del archivo coinciden. Sin coinciden no hay noticias nuevas
      // por lo que no se muestra notificaci�n. Si no coinciden, se muestra la notificaci�n.
      //

      // Si no existe el fichero newnotice.txt (fichero de texto que guarda el t�tulo de la noticia m�s reciente guardada por la app)
      if (FileExists(TPath.GetPublicPath+'/newnotice.txt')=False) then
         begin
              // Crea la notificaci�n
              Notificacion:=NotificationCenter1.CreateNotification;
              // Asigna un nombre a la notificaci�n
              Notificacion.Name:='Noticias_ba';
              // Asigna un t�tulo a la notificaci�n
              Notificacion.Title:='Noticias bandaancha.eu';
              // Asigna un texto a la notificaci�n
              Notificacion.AlertBody:=Label1.Text;
              // Activa sonido de notificaci�n
              Notificacion.EnableSound:=True;
              // Presenta notificaci�n al usuario
              NotificationCenter1.PresentNotification(Notificacion);
              // Libera notificaci�n de la memoria
              Notificacion.Free;
              // Crea lista de cadenas de caracteres
              cadenatitulo:=TStringList.Create;
              // A�ade el t�tulo de la noticia a la primera cadena
              cadenatitulo.Add(Label1.Text);
              // Graba esa lista como el archivo newnotice.txt
              cadenatitulo.SaveToFile(TPath.GetPublicPath+'/newnotice.txt');
              // Libera memoria de la lista de cadenas de caracteres
              cadenatitulo.Free;
         end
      else
          // Si el archivo newnotice.txt existe
          begin
               // Crea lista de cadenas de caracteres
               cadenatitulo:=TStringList.Create;
               // Carga en la lista el fichero newnotice.txt
               cadenatitulo.LoadFromFile(TPath.GetPublicPath+'/newnotice.txt');
               // Si la primera cadena (t�tulo guardado de la primera noticia) no coincide con el t�tulo de la primera noticia actual
               if (cadenatitulo[0]<>Label1.Text) then
                  begin
                       // Crea notificaci�n
                       Notificacion:=NotificationCenter1.CreateNotification;
                       // Asigna nombre a la notificaci�n
                       Notificacion.Name:='Noticias_ba';
                       // Asigna t�tulo a la notificaci�n
                       Notificacion.Title:='Noticias bandaancha.eu';
                       // Asigna texto a la notificaci�n
                       Notificacion.AlertBody:=Label1.Text;
                       // Activa sonido de notificaci�n
                       Notificacion.EnableSound:=True;
                       // Presenta notificaci�n al usuario
                       NotificationCenter1.PresentNotification(Notificacion);
                       // Libera notificaci�n de la memoria
                       Notificacion.Free;
                       // Cambia el primer elemento de la lista de cadena de caracteres por el t�tulo de la primera noticia
                       cadenatitulo[0]:=Label1.Text;
                       // Graba la lista como el archivo newnotice.txt
                       cadenatitulo.SaveToFile(TPath.GetPublicPath+'/newnotice.txt');
                       // Libera memoria de la lista de cadena de caracteres
                       cadenatitulo.Free;
                  end;
          end;

      //
      // Fin del c�digo para mostrar las notificaciones en pantalla
      //

        end
        else
            TThread.Synchronize(nil,procedure
            begin
                 // Muestra mensaje de error al usuario si el archivo de feed no se ha podido acceder despu�s de tres intentos
                 TDialogService.ShowMessage('Error al acceder al servidor de bandaancha.eu. Vuelva a intentarlo en los pr�ximos minutos.'+#13+
                 'Si despu�s de varios intentos no fuera posible el acceso a las noticias, contacte con el usuario djnacho a trav�s del foro baspeed de bandaancha.eu, o bien en la direcci�n de email djnacho@bandaancha.eu');
            end);
     end).Start;                                          // Inicia el hilo as�ncrono para mostrar los datos de las noticias
end;

procedure TForm1.ShowShareSheetAction10BeforeExecute(Sender: TObject);
begin
     ShowShareSheetAction10.TextMessage:=enlace[9];          // Comparte enlace a la noticia 9
end;

procedure TForm1.ShowShareSheetAction1BeforeExecute(Sender: TObject);
begin
     ShowShareSheetAction1.TextMessage:=enlace[1];          // Comparte enlace a la noticia 1
end;

procedure TForm1.ShowShareSheetAction2BeforeExecute(Sender: TObject);
begin
     ShowShareSheetAction2.TextMessage:=enlace[10];         // Comparte enlace a la noticia 10
end;

procedure TForm1.ShowShareSheetAction3BeforeExecute(Sender: TObject);
begin
     ShowShareSheetAction3.TextMessage:=enlace[2];          // Comparte enlace a la noticia 2
end;

procedure TForm1.ShowShareSheetAction4BeforeExecute(Sender: TObject);
begin
     ShowShareSheetAction4.TextMessage:=enlace[3];          // Comparte enlace a la noticia 3
end;

procedure TForm1.ShowShareSheetAction5BeforeExecute(Sender: TObject);
begin
     ShowShareSheetAction5.TextMessage:=enlace[4];          // Comparte enlace a la noticia 4
end;

procedure TForm1.ShowShareSheetAction6BeforeExecute(Sender: TObject);
begin
     ShowShareSheetAction6.TextMessage:=enlace[5];          // Comparte enlace a la noticia 5
end;

procedure TForm1.ShowShareSheetAction7BeforeExecute(Sender: TObject);
begin
     ShowShareSheetAction7.TextMessage:=enlace[6];          // Comparte enlace a la noticia 6
end;

procedure TForm1.ShowShareSheetAction8BeforeExecute(Sender: TObject);
begin
     ShowShareSheetAction8.TextMessage:=enlace[7];          // Comparte enlace a la noticia 7
end;

procedure TForm1.ShowShareSheetAction9BeforeExecute(Sender: TObject);
begin
     ShowShareSheetAction9.TextMessage:=enlace[8];          // Comparte enlace a la noticia 8
end;

// Rutina que ocurre al pulsar el bot�n de men� deslizante

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
     if (WebBrowser1.Visible=True) then                             // Si el navegador interno de la aplicaci�n est� visible
        begin
             ImageControl1.Bitmap:=WebBrowser1.MakeScreenshot;      // Hace una captura de pantalla del contenido de la pantalla
             WebBrowser1.Visible:=False;                            // Hace el navegador interno de la aplicaci�n invisible
             ImageControl1.Visible:=True;                           // Hace visible el contenido de la captura de pantalla
        end;
end;


// Rutina que se ejecuta cuando se pulsa el bot�n Atr�s del navegador interno de la aplicaci�n

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
     if (WebBrowser1.CanGoBack) then       // Si existen p�ginas para volver atr�s
        WebBrowser1.GoBack                 // Indica al navegador que navegue a la p�gina anterior
     else
         Toast('Imposible navegar m�s hacia atr�s');  // Si no es posible, muestra mensaje al usuario
end;


// Rutina que se ejecuta cuando se pulsa el bot�n de recargar del navegador interno de la aplicaci�n

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
     WebBrowser1.Reload;                   // Recarga la p�gina web actual
     Toast('Recargando p�gina web');       // Muestra mensaje al usuario cuando se recarga la p�gina web
end;


// Rutina que se ejecuta cuando se pulsa el bot�n de recargar todas las noticias en la pantalla principal de la aplicaci�n

procedure TForm1.SpeedButton4Click(Sender: TObject);

begin
     RellenaCampos;                        // Rellena todas las noticias
end;

// Rutina que se ejecuta cuando se acaba la carga de una p�gina en el navegador interno de la aplicaci�n

procedure TForm1.WebBrowser1DidFinishLoad(ASender: TObject);
begin
     FMXLoadingIndicator1.Active:=False;           // Para la animaci�n en el indicador de carga de p�gina web
     FMXLoadingIndicator1.Visible:=False;          // Hace invisible el indicador de carga de p�gina web
     SpeedButton3.Visible:=True;                   // Hace visible el bot�n de Atr�s del navegador
end;


// Rutina que se ejecuta cuando comienza la carga de una p�gina en el navegador interno de la aplicaci�n

procedure TForm1.WebBrowser1DidStartLoad(ASender: TObject);
begin
     SpeedButton3.Visible:=False;                 // Hace invisible el bot�n Atr�s del navegador
     FMXLoadingIndicator1.Visible:=True;          // Hace visible el indicador de carga de p�gina web
     FMXLoadingIndicator1.Active:=True;           // Inicia la animaci�n del indicador de carga de p�gina web
end;

end.
