// class TFormQueue
procedure TFormHeader.FullRefreshQueue;                                                  // Reopen a list of queue records in according to main queue
var
  i : Integer;
  msg : String;
begin
   List.Items.Clear;
   Queue.ClearbyInstance;
   for i := 0 to Queue.Len - 1 do
       begin
         msg := '';
         if (Queue.GetInstance(i) <> nil) then
           begin
         case Queue.GetInstance(i).Status of
              Modified: msg := msg + 'Modifiying';
              Inserted: msg := msg + 'Inserting';
              Deleted:  msg := msg + 'Deleting';
              Selected: msg := msg + '';
              None:     msg := msg + '';
         end;


         msg := msg + ' ' + Queue.GetInstance(i).Textrepr();
           end
         else
             msg := msg + Queue.Changes[i];
         //List.Items.Append(Queue.Changes[i]);
         List.Items.Append(msg);
       end;
end;
// class TFormQueue
function TFormHeader.ReadlogFile(filename: String) : Boolean;                           // Read a text file
var
  f : TextFile;
begin
  Result := False;
  if  FileExists(FileName) then
    begin
     try
      AssignFile(f, FileName); Reset(f);
      Result := Queue.LoadQueueFromFile(f);
     finally
       CloseFile(f);
     end;
    end;
end;

// class TFormQueue
function TFormHeader.WritelogFile(filename: String) : Boolean;                          // Write to a text file
var
  f : TextFile;
begin
    Result := False;
     try
      AssignFile(f, FileName); Rewrite(f);
      Result := Queue.SaveQueuetoFile(f);
     finally
       closeFile(f);
     end;
end;
 //
