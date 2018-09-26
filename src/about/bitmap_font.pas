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

  Unité bitmap_font
  =================

      *** SORRY ! ALL COMMENTS IN FRENCH. DO YOU NEED SOME HELP IN ENGLISH ? ***
                   *** IF YES THEN CONTACT ME WITH MY E-MAIL BELOW. ***

  Version     : 1.0

  Date        : 27/11/06 

  Description : Unité permettant de générer une image à partir d'une String.
                L'image contient en fait une carte de caractères (char map).

  Procédures  :

                - CreateBitmapLabel : Cette fonction est la fonction principale
                                      qui permet de créer le Bitmap correspondant
                                      en fonction de la chaine passée en paramètre.
  
  Auteur      : [big_fury]SiZiOUS

  E-mail      : sizious [at] yahoo [dot] fr

  URL         : http://sbibuilder.shorturl.com/

  Remarques   : L'utilité est bien sûr assez limitée mais bon... ce qui est inutile
                est forcément indispensable ! ;) De plus le code est très commenté
                à tel point que je me suis dit que trop de comms tue le comms, mais bon
                j'ai essayé de faire le plus simple possible en expliquant ce que
                je fais.

  TO DO       : Peut être convertir ça en composant, si ça intéresse du monde.
                Mais tel quel, c'est fonctionnel, et pas trop mal apparament.
}

unit bitmap_font;

interface

uses
  Windows, SysUtils, Forms, Controls, Graphics, Types;

{
  Une seule fonction disponible au public : Celle qui crée un label.

  Exemple : CreateBitmapLabel('Salut', bmp) va créer notre bitmap correspondant
            à "SALUT" (oui c'est converti en majuscule avant d'être traité)

            Voir le main.pas pour plus de détails.
}
procedure CreateBitmapLabel(const str : TCaption ; DestImage : TBitmap);

implementation

{
  Ce fichier de ressource contient la font bitmap. Regardez le fichier font.RC
  pour plus de détails. Pour compiler le RC, utilisez l'outil Make-RC de Delphi-FR
  ou sinon brcc32 de Borland fourni avec votre Delphi. Bien sur n'importe quel
  compiler de ressources peut faire l'affaire.
}

{
  Le define suivant sert à choisir la méthode d'implémentation pour les caractères
  spéciaux (au nombre de deux pour le moment, je n'ai pas la prétention de tout
  savoir, donc si vous avez encore une meilleure idée, merci de me le dire).

  Lisez plus loin pour plus de détails.

  La ligne suivante choisit actuellement la première méthode, si vous voulez la deuxième ...
}
{$DEFINE 1ST_IMPL_SPECIAL_CHARS} //... commentez cette ligne.


// Ce type n'est défini que dans la première implémentation pour les caractères spéciaux.
{$IFDEF 1ST_IMPL_SPECIAL_CHARS}

// ce record permet le stockage d'un caractère spécial où ... :
type
  TSpecialChar = record
    i : Integer;  // ... i est l'index où est situé le char dans le bitmap (voir plus loin comment le trouver)
    c : Char;     // ... c le char à convertir correspondant
  end;
  
{$ENDIF}
  
{
  Tous les caractères doivent faire la même taille. De plus le bitmap doit
  avoir une taille "juste".

  Exemple : Si un char fait 32x25 et qu'il y'a 10 colonnes et 6 lignes (de chars),
            le bitmap doit EXACTEMENT faire 320x150.

  Utilisez le logiciel OldSkool Chars Map Viewer fourni pour vous aider à
  construire votre table de caractères, à vérifier si votre bitmap est valide
  (dans le sens indiqué ci-dessus) et que chaque caractère sera découpé
  correctement (vous pouvez utiliser la fonction zoom en double cliquant
  sur le caractère correspondant).
}

const
  FONT_RESOURCE_NAME  : string = 'FONT'; // nom de la ressource contenant notre bitmap font.

  FONT_CHAR_WIDTH     : Word = 32; // largeur d'un caractère (donnée par Chars Map Viewer)
  FONT_CHAR_HEIGHT    : Word = 33; // hauteur d'un caractère

  UNKNOW_CHAR         : Word = 3; // caractère inconnu
  
  {
    Toutes les lettres de l'alphabet doivent se suivre dans l'ordre alphabétique.
    Vous spécifiez ensuite uniquement le début de l'alphabet au travers de la
    constante ALPHA_START_INDEX.

    Faites pareil pour les chiffres, ou le premier est le chiffre 0 puis 1 .. 9.

    N'oubliez pas, pour connaitre les indexes, utilisez Chars Map Viewer !
  }
  
  ALPHA_START_INDEX   : Word = 33; // De A .. Z
  NUMERIC_START_INDEX : Word = 16; // De 0 .. 9

  {
    A partir d'ici, c'est la gestion des caractères spéciaux.

    Ils peuvent vraiment être n'importe où dans le bitmap, de sorte que ça soit
    le plus flexible possible.

    Plusieurs implémentations sont disponibles.

    J'en ai fait une avec un tableau de TSpecialChar (en passant normalement le
    type doit être normalement défini entre const et var
    (schéma : unit -> interface -> implementation -> const -> type -> var) si
    je me rappelle bien...) et une autre implémentation à base de constantes et
    un case (un switch quoi).

    A vous de choisir celle que vous préférez.
  }

{$IFDEF 1ST_IMPL_SPECIAL_CHARS}
  {
    première implémentation :

    Les + :
      - plus simple à mettre à jour
      - plus "claire"

    Les - :
      - Une boucle est nécessaire pour trouver notre char : plus lent (sans doutes)
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
    deuxième implémentation :

    Les + :
      - Très rapide, on a accès au caractère "immédiatement" (je pense)

    Les - :
      - Chiante à mettre à jour (il faut modifier ici, puis plus loin dans le
        code, dans la méthode StrToIndex plus précisement.
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
  CharsCount : Word;  // nombre de caractères au total.
  Font : array of TBitmap; // tableau qui contient les chars découpés

//------------------------------------------------------------------------------

{
  Cette fonction traduit une chaine en indice de tableau.

  Exemple : abc renverra xx yy zz ... (oui notez le "var CharsIndexArray" :
            c'est donc un "param" de retour (sans rentrer dans les détails de
            pointeurs), bien que ça soit une "procédure" (et pas une fonction).
}
procedure StrToIndex(S : string ; var CharsIndexArray : array of Word);
var
  i : Integer;

{$IFDEF 1ST_IMPL_SPECIAL_CHARS}
  j : Integer;  // on fait une boucle dans le cas de la première implémentation
{$ENDIF}
  
begin
  S := UpperCase(S); // on travaille en majscule

  { un string commence à 1 donc on doit faire i - 1 tout le temps car le tableau
    de Font commence à 0 (surement moyen de faire ça bien - SetLength ? - mais bon...) }
  for i := 1 to Length(S) do
  begin
    // caractère 0 au début (s'il n'est pas reconnu ça sera celui là par défaut)
    CharsIndexArray[i - 1] := UNKNOW_CHAR;

    // Ensuite on traite de A à Z
    if (S[i] >= 'A') and (S[i] <= 'Z') then
      CharsIndexArray[i - 1] := (Ord(S[i]) - Ord('A')) + ALPHA_START_INDEX;

    // Puis de 0 à 9
    if (S[i] >= '0') and (S[i] <= '9') then
      CharsIndexArray[i - 1] := (Ord(S[i]) - Ord('0')) + NUMERIC_START_INDEX;

    // Les autres caractères spéciaux ...

{$IFDEF 1ST_IMPL_SPECIAL_CHARS}
    {
      Première possibilité d'implémentation : on recherche dans notre tableau de
      constantes le caractère voulu et on affecte sa valeur d'index associée
      à notre tableau résultat.
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
      Autre possibilité d'implémentation : avec des constantes à définir
      Super lourd mais peut être plus efficace.
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

  StrToIndex(str, Indexes); // on récupère tous les indices intéressants pour créer notre label
  // exemple : abc renverrais 00 01 02 (si A est situé à la position 0 ...).

  // ca y'est on a tout ce qu'il faut
  for i := Low(Indexes) to High(Indexes) do
  begin
    _char := Font[Indexes[i]];

    _dest_r := Rect(i * FONT_CHAR_WIDTH, 0, (i * FONT_CHAR_WIDTH) + FONT_CHAR_WIDTH, FONT_CHAR_HEIGHT);
    DestImage.Canvas.CopyRect(_dest_r, _char.Canvas, Rect(0, 0, FONT_CHAR_WIDTH, FONT_CHAR_HEIGHT)); // écriture dans le Bitmap
  end;

end;

//------------------------------------------------------------------------------

// procédure de chargement de la police (font).
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

    //découpage
    X := 0;
    Y := 0;

    repeat
      i := (X div FONT_CHAR_WIDTH) + ((Y div FONT_CHAR_HEIGHT) * (_font_src.Width div FONT_CHAR_WIDTH));

      //extraction de la police
      Font[i].Canvas.CopyRect(Rect(0, 0, FONT_CHAR_WIDTH, FONT_CHAR_HEIGHT),
        _font_src.Canvas, Rect(X, Y, FONT_CHAR_WIDTH + X, FONT_CHAR_HEIGHT + Y));

      //décalages 
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

// détruire le tableau de font alloué précédement
procedure FinalizeFont();
var
  i : Integer;
  
begin
  for i := 0 to CharsCount - 1 do
    Font[i].Free;
end;

//------------------------------------------------------------------------------

// InitializeFont est appellée lors du lancement de l'unité par l'executable
initialization
  InitializeFont();

{
  FinalizeFont est appellée lorsque l'executable est quitté (plus précisement
  quand l'unité est détruite je crois).
}
finalization
  FinalizeFont();

//------------------------------------------------------------------------------
      
end.
