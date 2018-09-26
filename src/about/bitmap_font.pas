{
  [big_fury]
  888888888    8888  888888888888  8888     888888888     8888      8888   888888888
8888888888888  8888  888888888888  8888   8888888888888   8888      8888 8888888888888
8888     8888              88888         8888       8888  8888      8888 8888     8888
888888888      8888      888888    8888 8888         8888 8888      8888 888888888
  8888888888   8888     88888      8888 8888         8888 8888      8888   88888888888
       888888  8888   88888        8888 8888         8888 8888      8888         888888
8888      8888 8888  88888         8888  8888       8888  8888      8888 8888      8888
8888888888888  8888 88888888888888 8888   8888888888888    888888888888  8888888888888
  8888888888   8888 88888888888888 8888     888888888       8888888888     8888888888

  Unit� bitmap_font
  =================

      *** SORRY ! ALL COMMENTS IN FRENCH. DO YOU NEED SOME HELP IN ENGLISH ? ***
                   *** IF YES THEN CONTACT ME WITH MY E-MAIL BELOW. ***

  Version     : 1.0

  Date        : 27/11/06 

  Description : Unit� permettant de g�n�rer une image � partir d'une String.
                L'image contient en fait une carte de caract�res (char map).

  Proc�dures  :

                - CreateBitmapLabel : Cette fonction est la fonction principale
                                      qui permet de cr�er le Bitmap correspondant
                                      en fonction de la chaine pass�e en param�tre.
  
  Auteur      : [big_fury]SiZiOUS

  E-mail      : sizious [at] yahoo [dot] fr

  URL         : http://sbibuilder.shorturl.com/

  Remarques   : L'utilit� est bien s�r assez limit�e mais bon... ce qui est inutile
                est forc�ment indispensable ! ;) De plus le code est tr�s comment�
                � tel point que je me suis dit que trop de comms tue le comms, mais bon
                j'ai essay� de faire le plus simple possible en expliquant ce que
                je fais.

  TO DO       : Peut �tre convertir �a en composant, si �a int�resse du monde.
                Mais tel quel, c'est fonctionnel, et pas trop mal apparament.
}

unit bitmap_font;

interface

uses
  Windows, SysUtils, Forms, Controls, Graphics, Types;

{
  Une seule fonction disponible au public : Celle qui cr�e un label.

  Exemple : CreateBitmapLabel('Salut', bmp) va cr�er notre bitmap correspondant
            � "SALUT" (oui c'est converti en majuscule avant d'�tre trait�)

            Voir le main.pas pour plus de d�tails.
}
procedure CreateBitmapLabel(const str : TCaption ; DestImage : TBitmap);

implementation

{
  Ce fichier de ressource contient la font bitmap. Regardez le fichier font.RC
  pour plus de d�tails. Pour compiler le RC, utilisez l'outil Make-RC de Delphi-FR
  ou sinon brcc32 de Borland fourni avec votre Delphi. Bien sur n'importe quel
  compiler de ressources peut faire l'affaire.
}

{
  Le define suivant sert � choisir la m�thode d'impl�mentation pour les caract�res
  sp�ciaux (au nombre de deux pour le moment, je n'ai pas la pr�tention de tout
  savoir, donc si vous avez encore une meilleure id�e, merci de me le dire).

  Lisez plus loin pour plus de d�tails.

  La ligne suivante choisit actuellement la premi�re m�thode, si vous voulez la deuxi�me ...
}
{$DEFINE 1ST_IMPL_SPECIAL_CHARS} //... commentez cette ligne.


// Ce type n'est d�fini que dans la premi�re impl�mentation pour les caract�res sp�ciaux.
{$IFDEF 1ST_IMPL_SPECIAL_CHARS}

// ce record permet le stockage d'un caract�re sp�cial o� ... :
type
  TSpecialChar = record
    i : Integer;  // ... i est l'index o� est situ� le char dans le bitmap (voir plus loin comment le trouver)
    c : Char;     // ... c le char � convertir correspondant
  end;
  
{$ENDIF}
  
{
  Tous les caract�res doivent faire la m�me taille. De plus le bitmap doit
  avoir une taille "juste".

  Exemple : Si un char fait 32x25 et qu'il y'a 10 colonnes et 6 lignes (de chars),
            le bitmap doit EXACTEMENT faire 320x150.

  Utilisez le logiciel OldSkool Chars Map Viewer fourni pour vous aider �
  construire votre table de caract�res, � v�rifier si votre bitmap est valide
  (dans le sens indiqu� ci-dessus) et que chaque caract�re sera d�coup�
  correctement (vous pouvez utiliser la fonction zoom en double cliquant
  sur le caract�re correspondant).
}

const
  FONT_RESOURCE_NAME  : string = 'FONT'; // nom de la ressource contenant notre bitmap font.

  FONT_CHAR_WIDTH     : Word = 32; // largeur d'un caract�re (donn�e par Chars Map Viewer)
  FONT_CHAR_HEIGHT    : Word = 33; // hauteur d'un caract�re

  UNKNOW_CHAR         : Word = 3; // caract�re inconnu
  
  {
    Toutes les lettres de l'alphabet doivent se suivre dans l'ordre alphab�tique.
    Vous sp�cifiez ensuite uniquement le d�but de l'alphabet au travers de la
    constante ALPHA_START_INDEX.

    Faites pareil pour les chiffres, ou le premier est le chiffre 0 puis 1 .. 9.

    N'oubliez pas, pour connaitre les indexes, utilisez Chars Map Viewer !
  }
  
  ALPHA_START_INDEX   : Word = 33; // De A .. Z
  NUMERIC_START_INDEX : Word = 16; // De 0 .. 9

  {
    A partir d'ici, c'est la gestion des caract�res sp�ciaux.

    Ils peuvent vraiment �tre n'importe o� dans le bitmap, de sorte que �a soit
    le plus flexible possible.

    Plusieurs impl�mentations sont disponibles.

    J'en ai fait une avec un tableau de TSpecialChar (en passant normalement le
    type doit �tre normalement d�fini entre const et var
    (sch�ma : unit -> interface -> implementation -> const -> type -> var) si
    je me rappelle bien...) et une autre impl�mentation � base de constantes et
    un case (un switch quoi).

    A vous de choisir celle que vous pr�f�rez.
  }

{$IFDEF 1ST_IMPL_SPECIAL_CHARS}
  {
    premi�re impl�mentation :

    Les + :
      - plus simple � mettre � jour
      - plus "claire"

    Les - :
      - Une boucle est n�cessaire pour trouver notre char : plus lent (sans doutes)
  }
  SPECIAL_CHARS : array[0..11] of TSpecialChar = (
    (i:  0 ; c: '?'),   // ?
    (i:  1 ; c: '!'),   // !
    (i:  7 ; c: ''''),  // '
    (i:  8 ; c: '<'),   // <
    (i:  9 ; c: '>'),   // >
    (i: 12 ; c: ','),   // ,
    (i: 13 ; c: '-'),   // -
    (i: 14 ; c: '.'),   // .
    (i: 26 ; c: ':'),   // :
    (i: 27 ; c: ';'),   // ;
    (i: 29 ; c: '='),   // =
    (i: 59 ; c: ' ')    // espace
  );

{$ELSE}

  {
    deuxi�me impl�mentation :

    Les + :
      - Tr�s rapide, on a acc�s au caract�re "imm�diatement" (je pense)

    Les - :
      - Chiante � mettre � jour (il faut modifier ici, puis plus loin dans le
        code, dans la m�thode StrToIndex plus pr�cisement.
  }
  
  EXCL        : Word = 1;
  ARROW_LEFT  : Word = 8;
  ARROW_RIGHT : Word = 9;
  SPACE       : Word = 0;
  APOSTROP    : Word = 7;
  MINUS       : Word = 13;
  TWO_DOT     : Word = 26;
  DOT         : Word = 14;
  COMMA       : Word = 12;
  
{$ENDIF}
  
var
  CharsCount : Word;  // nombre de caract�res au total.
  Font : array of TBitmap; // tableau qui contient les chars d�coup�s

//------------------------------------------------------------------------------

{
  Cette fonction traduit une chaine en indice de tableau.

  Exemple : abc renverra xx yy zz ... (oui notez le "var CharsIndexArray" :
            c'est donc un "param" de retour (sans rentrer dans les d�tails de
            pointeurs), bien que �a soit une "proc�dure" (et pas une fonction).
}
procedure StrToIndex(S : string ; var CharsIndexArray : array of Word);
var
  i : Integer;

{$IFDEF 1ST_IMPL_SPECIAL_CHARS}
  j : Integer;  // on fait une boucle dans le cas de la premi�re impl�mentation
{$ENDIF}
  
begin
  S := UpperCase(S); // on travaille en majscule

  { un string commence � 1 donc on doit faire i - 1 tout le temps car le tableau
    de Font commence � 0 (surement moyen de faire �a bien - SetLength ? - mais bon...) }
  for i := 1 to Length(S) do
  begin
    // caract�re 0 au d�but (s'il n'est pas reconnu �a sera celui l� par d�faut)
    CharsIndexArray[i - 1] := UNKNOW_CHAR;

    // Ensuite on traite de A � Z
    if (S[i] >= 'A') and (S[i] <= 'Z') then
      CharsIndexArray[i - 1] := (Ord(S[i]) - Ord('A')) + ALPHA_START_INDEX;

    // Puis de 0 � 9
    if (S[i] >= '0') and (S[i] <= '9') then
      CharsIndexArray[i - 1] := (Ord(S[i]) - Ord('0')) + NUMERIC_START_INDEX;

    // Les autres caract�res sp�ciaux ...

{$IFDEF 1ST_IMPL_SPECIAL_CHARS}
    {
      Premi�re possibilit� d'impl�mentation : on recherche dans notre tableau de
      constantes le caract�re voulu et on affecte sa valeur d'index associ�e
      � notre tableau r�sultat.
    }
    j := Low(SPECIAL_CHARS);
    repeat
      if SPECIAL_CHARS[j].c = S[i] then
      begin
        CharsIndexArray[i - 1] := SPECIAL_CHARS[j].i;
        Break;  // beurk n'est ce pas ?
      end;
      Inc(j);
    until j > High(SPECIAL_CHARS);

{$ELSE}

    {
      Autre possibilit� d'impl�mentation : avec des constantes � d�finir
      Super lourd mais peut �tre plus efficace.
    }
    case S[i] of
       '!'  : CharsIndexArray[i - 1] := EXCL;
       '<'  : CharsIndexArray[i - 1] := ARROW_LEFT;
       '>'  : CharsIndexArray[i - 1] := ARROW_RIGHT;
       ' '  : CharsIndexArray[i - 1] := SPACE;
       '''' : CharsIndexArray[i - 1] := APOSTROP;
       '-'  : CharsIndexArray[i - 1] := MINUS;
       ':'  : CharsIndexArray[i - 1] := TWO_DOT;
       '.'  : CharsIndexArray[i - 1] := DOT;
       ','  : CharsIndexArray[i - 1] := COMMA;
    end;
    
{$ENDIF}

  end;
end;

//------------------------------------------------------------------------------

{
  Ceci est notre fonction principale. Elle permet de traduire notre texte en image.
  C'est la seule fonction publique.
}
procedure CreateBitmapLabel(const str : TCaption ; DestImage : TBitmap);
var
  Indexes : array of Word;
  i : integer;
  _char : TBitmap;

  _dest_r : TRect;

begin
  //initialisation
  DestImage.Width := Length(str) * FONT_CHAR_WIDTH;
  DestImage.Height := FONT_CHAR_HEIGHT;

  SetLength(Indexes, Length(str)); //on peut pas redimentionner un tableau en parametre (?)

  StrToIndex(str, Indexes); // on r�cup�re tous les indices int�ressants pour cr�er notre label
  // exemple : abc renverrais 00 01 02 (si A est situ� � la position 0 ...).

  // ca y'est on a tout ce qu'il faut
  for i := Low(Indexes) to High(Indexes) do
  begin
    _char := Font[Indexes[i]];

    _dest_r := Rect(i * FONT_CHAR_WIDTH, 0, (i * FONT_CHAR_WIDTH) + FONT_CHAR_WIDTH, FONT_CHAR_HEIGHT);
    DestImage.Canvas.CopyRect(_dest_r, _char.Canvas, Rect(0, 0, FONT_CHAR_WIDTH, FONT_CHAR_HEIGHT)); // �criture dans le Bitmap
  end;

end;

//------------------------------------------------------------------------------

// proc�dure de chargement de la police (font).
procedure InitializeFont();
var
  X, Y : Word;
  i : Word;
  _font_src : TBitmap;

begin
  _font_src := TBitmap.Create;
  try

    _font_src.Handle := LoadBitmap(hInstance, PChar(FONT_RESOURCE_NAME)); //chargement depuis la section ressource

    //initialisation du tableau de Bitmap
    CharsCount := (_font_src.Width div FONT_CHAR_WIDTH) * (_font_src.Height div FONT_CHAR_HEIGHT);
    SetLength(Font, CharsCount); // redimensionner le tableau de font

    // on le remplit
    for i := 0 to CharsCount - 1 do
    begin
      if Assigned(Font[i]) then FreeAndNil(Font[i]); // dans le cas ou l'utilisateur rappelerais pour une raison x ou y cette fonction
      Font[i] := TBitmap.Create;
      Font[i].Width := FONT_CHAR_WIDTH;
      Font[i].Height := FONT_CHAR_HEIGHT;
    end;

    //d�coupage
    X := 0;
    Y := 0;

    repeat
      i := (X div FONT_CHAR_WIDTH) + ((Y div FONT_CHAR_HEIGHT) * (_font_src.Width div FONT_CHAR_WIDTH));

      //extraction de la police
      Font[i].Canvas.CopyRect(Rect(0, 0, FONT_CHAR_WIDTH, FONT_CHAR_HEIGHT),
        _font_src.Canvas, Rect(X, Y, FONT_CHAR_WIDTH + X, FONT_CHAR_HEIGHT + Y));

      //d�calages 
      Inc(X, FONT_CHAR_WIDTH);

      if (X >= _font_src.Width) then
      begin
        Inc(Y, FONT_CHAR_HEIGHT);
        X := 0;
      end;

    until (Y >= _font_src.Height);

  finally
    _font_src.Free;
  end;
end;

//------------------------------------------------------------------------------

// d�truire le tableau de font allou� pr�c�dement
procedure FinalizeFont();
var
  i : Integer;
  
begin
  for i := 0 to CharsCount - 1 do
    Font[i].Free;
end;

//------------------------------------------------------------------------------

// InitializeFont est appell�e lors du lancement de l'unit� par l'executable
initialization
  InitializeFont();

{
  FinalizeFont est appell�e lorsque l'executable est quitt� (plus pr�cisement
  quand l'unit� est d�truite je crois).
}
finalization
  FinalizeFont();

//------------------------------------------------------------------------------
      
end.
