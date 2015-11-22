package com.fancynode.mvc.command
{
	import com.fancynode.mvc.ns_fancynode_mvc;
	import com.fancynode.mvc.notif.Notif;
	import com.fancynode.mvc.utils.ClsUtil;
	
	import avmplus.getQualifiedClassName;

	use namespace ns_fancynode_mvc;
	/**
	 * 组合命令 
	 * @author featherJ
	 * 
	 */	
	public class MultiCommand extends Command
	{
		private var _subCommandList:Vector.<Class>;
		/**
		 * 添加一个子命令 
		 * @param command 需要是Command的子类。
		 */		
		protected function addSubCommand(command:Class):void
		{
			if(!ClsUtil.isChildOf(command,Command))
				throw new Error("添加的Command类"+getQualifiedClassName(command)+"需要是"+getQualifiedClassName(Command)+"的子类");
			if(!_subCommandList)
				_subCommandList = new Vector.<Class>();
			_subCommandList.push(command);
		}
		
		override protected function execute(notif:Notif):void
		{
			if(_subCommandList)
			{
				while(_subCommandList.length>0)
				{
					var cls:Class = _subCommandList.shift();
					var command:Command = new cls();
					command.setContext(_context);
					command.doExecute(notif);
					command.delContext();
				}
				_subCommandList = null;
			}
			super.execute(notif);
		}
	}
}