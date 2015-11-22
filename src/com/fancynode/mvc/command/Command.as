package com.fancynode.mvc.command
{
	import com.fancynode.mvc.Context;
	import com.fancynode.mvc.ns_fancynode_mvc;
	import com.fancynode.mvc.mediator.Mediator;
	import com.fancynode.mvc.notif.Notif;
	import com.fancynode.mvc.utils.ClsUtil;
	import com.fancynode.mvc.utils.InjectUtil;
	
	import avmplus.getQualifiedClassName;

	use namespace ns_fancynode_mvc;
	/**
	 * 命令 
	 * @author featherJ
	 * 
	 */	
	public class Command
	{
		ns_fancynode_mvc var _context:Context
		/**
		 * 设置域 
		 * @param context
		 */		
		ns_fancynode_mvc function setContext(context:Context):void
		{
			_context = context;
		}
		/**
		 * 移除域 
		 * 
		 */		
		ns_fancynode_mvc function delContext():void
		{
			_context = null;
		}
		
		/**
		 * 执行 
		 * @param notif
		 * 
		 */		
		ns_fancynode_mvc function doExecute(notif:Notif):void
		{
			//注入数据
			InjectUtil.injectModel(this,_context);
			//注入中介者
			InjectUtil.injectMediator(this,_context);
			//执行
			execute(notif);
			//清空所有public变量
			InjectUtil.clearProperty(this);
		}
		/**
		 * 执行
		 * @param notif 传入的消息
		 * 
		 */		
		protected function execute(notif:Notif):void
		{
			
		}
		
		/**
		 * 绑定一个消息和命令的对应。 控制层所有命令均为即使创建即使销毁。
		 * @param notifType
		 * @param command 需要是Command的子类。
		 * 
		 */		
		protected function mapCommand(notifType:String,command:Class):void
		{
			if(!ClsUtil.isChildOf(command,Command))
				throw new Error("绑定的Command类"+getQualifiedClassName(command)+"需要是"+getQualifiedClassName(Command)+"的子类");
			_context.mapCommand(notifType,command);
		}
		/**
		 * 解绑一个消息和Command的对应。 
		 * @param notifType
		 * @param command
		 * 
		 */		
		protected function unMapCommand(notifType:String,command:Class):void
		{
			_context.unMapCommand(notifType,command);
		}
		
		/**
		 * 绑定一个中介者。视图层所有中介均为单例。在绑定的时候即调用了该中介者的init()方法。
		 * 同一个域内相同类型的终结者只能绑定一次。除非该终结者已经解绑，否则无法继续绑定。
		 * 绑定之后会及时为该command进行[Inject]标签的检测，并注入对应的mediator
		 * @param mediator 需要是Mediator的子类
		 * 
		 */		
		protected function mapMediator(mediator:Class):void
		{
			if(!ClsUtil.isChildOf(mediator,Mediator))
				throw new Error("绑定的Mediator类"+getQualifiedClassName(mediator)+"需要是"+getQualifiedClassName(Mediator)+"的子类");
			_context.mapMediator(mediator);
			InjectUtil.injectMediator(this,_context);
		}
		/**
		 * 解绑一个中介者类型。 
		 * @param mediator
		 * 
		 */		
		protected function unMapMediator(mediator:Class):void
		{
			_context.unMapMediator(mediator);
		}
	}
}