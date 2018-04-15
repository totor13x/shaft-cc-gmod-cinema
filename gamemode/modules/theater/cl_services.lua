print("cl")
DT = DT or {}
net.Receive('UpdateDT',function()
	DT = net.ReadTable()
end)