unit uListView;

interface

uses FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView, FMX.Graphics;

type
    TMyListview = class(TListView)
    private


    public
        class procedure SetupItem(lv: TListView; Item: TListViewItem; img_uncheck,
                                  img_check: TBitmap); static;
        class procedure SelecionarItem(lv: TListView; Item: TListViewItem;
                                       img_uncheck, img_check: TBitmap); static;
        class function SelectedCount(lview: TListView): integer; static;
        class procedure AddItem(lv: TListView; codigo, descricao: string;
                                bmp: TBitmap); static;
        class procedure LimpaLista(lv: TListView); static;
        class procedure SelecionarTodos( lv: TListView;
                                           xCheck: Boolean;
                                           img_uncheck, img_check: TBitmap);  static;
        class procedure Selecionados(lv:TListView;var selecao:string); static;

end;


implementation

uses
  UPrincipal, uLogin;

class procedure TMyListview.SetupItem(lv: TListView; Item: TListViewItem;
                                  img_uncheck, img_check: TBitmap);
begin
    with item do
    begin
        if Checked then
            TListItemImage(Objects.FindDrawable('ImgCheckbox')).Bitmap := img_check
        else
            TListItemImage(Objects.FindDrawable('ImgCheckbox')).Bitmap := img_uncheck;
    end;
end;


class procedure TMyListview.LimpaLista(lv: TListView);
begin
  lv.Items.Clear;
end;

class procedure TMyListview.Selecionados(lv: TListView; var selecao:string);
var x:Integer;
   todos:string;
begin
  selecao:='';
  for x := lv.ItemCount - 1 downto 0 do
  begin
    todos:=todos+lv.Items[x].TagString+';';
    if lv.Items[x].Checked=True then
      selecao:=selecao+lv.Items[x].TagString+';';
  end;

  if selecao='' then
    selecao:=todos;
end;

class procedure TMyListview.SelecionarItem(lv: TListView; Item: TListViewItem;
                                           img_uncheck, img_check: TBitmap);
begin
    Item.Checked := NOT Item.Checked;
    SetupItem(lv, item, img_uncheck, img_check);
end;

class procedure TMyListview.SelecionarTodos(lv: TListView;
                                           xCheck: Boolean;
                                           img_uncheck, img_check: TBitmap);
var x:Integer;
begin
  for x := lv.ItemCount - 1 downto 0 do
  begin
    lv.Items[x].Checked:=xCheck;
    lv.Items[x];
    SetupItem(lv,lv.Items[x],img_uncheck, img_check);
  end;


end;

class function TMyListview.SelectedCount(lview: TListView): integer;
var
    x : integer;
begin
    Result := 0;

    for x := lview.ItemCount - 1 downto 0 do
        if lview.Items[x].Checked then
            Inc(Result);
end;

class procedure TMyListview.AddItem(lv: TListView;
                                    codigo, descricao: string;
                                    bmp: TBitmap);
begin
    //lv.Items.AddItem()

    with lv.Items.Add do
    begin
        Height := 60;
        TagString := codigo;
        Checked := true;
        TListItemText(Objects.FindDrawable('TxtDescricao')).Text := descricao;
        TListItemImage(Objects.FindDrawable('ImgCheckbox')).Bitmap := bmp;
    end;
end;


end.
