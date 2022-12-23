local inputManager = {}

local UserInputService = game:GetService("UserInputService")
local isPressing = false
local counter = 0
local clickCallbacks = {}
local holdBcallbacks = {}

function InputMouse()
	while task.wait() do
		if counter > 15 and isPressing then
			for i,v in holdBcallbacks do
				coroutine.wrap(v)()
			end		
		end
		counter = counter+1
	end

end
local Coroutine
UserInputService.InputBegan:Connect(function(input:InputObject,gameProccess:boolean)
	if gameProccess then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isPressing = true
		if not Coroutine or coroutine.status(Coroutine)=="dead" then
			counter = 0
			Coroutine = coroutine.create(InputMouse)
			coroutine.resume(Coroutine)
		end

	end
end)
UserInputService.InputEnded:Connect(function(input:InputObject,gameProccess:boolean)
	if gameProccess then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isPressing = false
		coroutine.close(Coroutine)
		if counter < 15 then
			for i,v in clickCallbacks do
				coroutine.wrap(v)()
			end	

		end
	end
end)

function inputManager.OnClick(callback)
	table.insert(clickCallbacks,callback)
end

function inputManager.OnHold(callback)
	table.insert(holdBcallbacks,callback)
end
inputManager.OnHold(function()
	print("holding")
end)
inputManager.OnClick(function()
	print("click")
end)

--TODO mobile support
return inputManager
