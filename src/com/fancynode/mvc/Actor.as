package com.fancynode.mvc
{
	import com.fancynode.mvc.command.Command;
	import com.fancynode.mvc.notif.Notif;
	import com.fancynode.mvc.utils.ClsUtil;
	
	import flash.utils.Dictionary;
	
	import avmplus.getQualifiedClassName;
	
	use namespace ns_fancynode_mvc;
	[ExcludeClass]
	/**
	 * 消息总线 
	 * @author featherJ
	 * 
	 */	
	public class Actor
	{ 
		
		private var _context:Context;
		public function Actor(context:Context)
		{
			_context = context;
		}
		/**
		 * 发送一个消息  
		 * @param notif
		 * @return 如果成功调度了消息，则值为 true。值 false 表示失败或对消息调用了 preventDefault()。
		 */		
		ns_fancynode_mvc function sendNotif(notif:Notif):Boolean
		{
			var commandList:Vector.<Class> = commandMap[notif.type];
			if(commandList)
			{
				for(var i:int = 0;i<commandList.length;i++)
				{
					var command:Command = new commandList[i];
					command.setContext(_context);
					command.doExecute(notif);
					command.delContext();
				}
			}
			var isPreventDefault:Boolean = false;
			var notifList:Vector.<Function> = notifMap[notif.type];
			if(notifList)
			{
				for(i = 0;i<notifList.length;i++)
				{
					notifList[i](notif);
					if(notif.isDefaultPrevented())
						isPreventDefault = true;
				}
			}
			return !isPreventDefault;
		}
		
		private var notifMap:Dictionary = new Dictionary();
		/**
		 * 添加一个消息回调 
		 * @param notifType
		 * @param listener,如：listener(notif:Notif):void
		 * 
		 */		
		ns_fancynode_mvc function addNotifListener(notifType:String,listener:Function):void
		{
			if(!listener || listener.length != 1)
				throw new Error("添加的listener需要1个参数，不能是"+listener.length+"个参数。");
			if(!notifMap[notifType])
			{
				notifMap[notifType] = new Vector.<Function>;
			}
			var notifList:Vector.<Function> = notifMap[notifType];
			notifList.push(listener);
		}
		
		/**
		 * 移除一个 消息回调
		 * @param notifType
		 * @param listener
		 * 
		 */		
		ns_fancynode_mvc function removeNotifListener(notifType:String,listener:Function):void
		{
			if(notifMap[notifType])
			{
				var notifList:Vector.<Function> = notifMap[notifType];
				for(var i:int = 0;i<notifList.length;i++)
				{
					if(notifList[i] == listener)
					{
						notifList.splice(i,1);
						break;
					}
				}
			}
		}
		
		private var commandMap:Dictionary = new Dictionary();
		/**
		 * 绑定一个消息和Command的对应。 控制层所有Command均为即使创建即使销毁。
		 * @param notifType
		 * @param command
		 * 
		 */		
		ns_fancynode_mvc function mapCommand(notifType:String,command:Class):void
		{
			if(!ClsUtil.isChildOf(command,Command))
				throw new Error("绑定的Command类"+getQualifiedClassName(command)+"需要是"+getQualifiedClassName(Command)+"的子类");
			if(!commandMap[notifType])
			{
				commandMap[notifType] = new Vector.<Class>;
			}
			var commandList:Vector.<Class> = commandMap[notifType];
			commandList.push(command);
		}
		
		
		/**
		 * 解绑一个消息和Command的对应。 
		 * @param notifType
		 * @param command
		 * 
		 */		
		ns_fancynode_mvc function unMapCommand(notifType:String,command:Class):void
		{
			if(commandMap[notifType])
			{
				var commandList:Vector.<Class> = commandMap[notifType];
				for(var i:int = 0;i<commandList.length;i++)
				{
					if(commandList[i] == command)
					{
						commandList.splice(i,1);
						break;
					}
				}
			}
		}
	}
}