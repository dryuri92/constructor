// TFormHeader
procedure TFormHeader.RefreshGTForm(Const ClearEditform : Boolean);             // Refresh form Geometry table
var
  i : Integer;
  pGeom : PTGeometry;
begin
   RefreshGeomTable;
   if QueryGeom.RecordCount > 0 then
      begin
           ToolBar2.Enabled := True;
           Tabsheet6.Enabled := True;
      end
   else
       Clearall;
   if ClearEditform then
     if Assigned(FormGeomedit) then
          begin

          for i := Editing_geometry.Len - 1 downto 0  do
              begin
                   pGeom := Editing_geometry.Items[i];
                   if ((pGeom^.Status = None) or not(pGeom^.GetQueord())) then FormGeomedit.Excludegeometry(Editing_geometry.Items[i]);
              end;

          FormGeomedit.UpdateExpanded(FormGeomedit.GeometryTree.Items[0]);
          FormGeomedit.Clearmodform;
          Editing_geometry.ClearListbyNone;
          end;
end;
// TFormHeader
procedure TFormHeader.Editgeometry(id : Integer);                                       // Call editing geometry form
var
  temp : TInstanceConstr;
begin
  temp:=nil;
  if (id > 0) then
    if Editing_geometry.IsIn([id]) then
       begin
            temp := Editing_geometry.SearchbyID([id]);
            FormGeomedit.Refreshgeom(@temp);
       end
    else
       FormGeomedit.Refreshgeom(id,Selected);

end;



// TFormHeader
procedure TFormHeader.RefreshGeomTable;                                         // Refresh geometry table
begin
   if (QueryGeom.Active=True) then QueryGeom.Close;
        QueryGeom.Prepare;

  try
         QueryGeom.Open;
         QueryGeom.Fetchall;
         DBlookupGeom.KeyValue := Querygeom.FieldbyName('ID').ASinteger;;
  except
    on
      E: Exception do
    begin
      TransactionGeom.Rollback;
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;                   
