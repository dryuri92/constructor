    // class TFormmattable
procedure TFormHeader.Clearall;                                               // All components are disabled
begin
   ToolBar1.Enabled := False;
   Tabsheet5.Enabled := False;
   ToolBar2.Enabled := False;
   Tabsheet6.Enabled := False;
   ToolBar3.Enabled := False;
   Tabsheet7.Enabled := False;
end;

// class TFormmattable
procedure TFormHeader.RefreshMTForm(Const ClearEditform : Boolean);           // Refresh form Material table
var
  i : Integer;
  pMat : PTMatter;
begin
   RefreshMatTable;
   if QueryMat.RecordCount > 0 then
      begin
           ToolBar1.Enabled := True;
           Tabsheet5.Enabled := True;
      end
   else
       Clearall;
   if ClearEditform then
     if Assigned(Formmatedit) then
          begin

          for i := Editing_material.Len - 1 downto 0  do
              begin
                   pMat := Editing_material.Items[i];
                   if ((pMat^.Status = None) or not(pMat^.GetQueord())) then Formmatedit.ExcludeMaterial(Editing_material.Items[i]);
              end;
          Formmatedit.UpdateExpanded(Formmatedit.MaterialTree.Items[0]);
          Formmatedit.Clearmodform;
          Editing_material.ClearListbyNone;
          end;

end;
procedure TFormHeader.Editmaterial(id : Integer);
var
  temp : TInstanceConstr;
begin
  temp:=nil;
  if (id > 0) then
    if Editing_material.IsIn([id]) then
       begin
            temp := Editing_material.SearchbyID([id]);
            FormMatedit.Refreshmat(@temp);
       end
    else
       FormMatedit.Refreshmat(id,Selected);

end;
// class TFormmattable
procedure TFormHeader.RefreshMatTable;                                        // Refresh material table

begin
    if (QueryMat.Active=True) then QueryMat.Close;
        QueryMat.Prepare;

  try
         QueryMat.Open;
         QueryMat.Fetchall;
         DBlookupMAT.KeyValue := QueryMat.FieldbyName('ID').ASinteger;
  except
    on
      E: Exception do
    begin
      TransactionMat.Rollback;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;
