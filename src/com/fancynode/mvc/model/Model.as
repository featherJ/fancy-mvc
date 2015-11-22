package com.fancynode.mvc.model
{
	import com.fancynode.mvc.Actor;
	import com.fancynode.mvc.Context;
	import com.fancynode.mvc.ns_fancynode_mvc;
	import com.fancynode.mvc.notif.Notif;

	use namespace ns_fancynode_mvc;
	/**
	 * 数据模型 
	 * @author featherJ
	 */	
	public class Model
	{
		private var _actor:Actor;
		/**
		 * 设置消息总线 
		 * @param actor
		 */		
		ns_fancynode_mvc function setActor(actor:Actor):void
		{
			_actor = actor;
		}
		/**
		 * 移除消息总线 
		 */		
		ns_fancynode_mvc function delActor():void
		{
			_actor = null;
		}
		
		private var _context:Context;
		/**
		 * 设置所在域 
		 * @param context
		 * 
		 */		
		ns_fancynode_mvc function setContext(context:Context):void
		{
			_context = context;
		}
		/**
		 * 移除所在域 
		 */		
		ns_fancynode_mvc function delContext():void
		{
			_context = null
		}
		
		
		
		/**
		 * 执行初始化 
		 */		
		ns_fancynode_mvc function doInit():void
		{
			init();
		}
		/**
		 * 初始化 
		 * 
		 */		
		protected function init():void
		{
			
		}
		
		/**
		 * 通过key获取在所在域中绑定的实例 
		 * @param key
		 * @return 
		 * 
		 */		
		final protected function getInstance(key:*):*
		{
			return _context ? _context.doGetInstance(key) : null;
		}
		
		/**
		 * 发送一个消息 
		 * @param notif
		 * @return 如果成功调度了消息，则值为 true。值 false 表示失败或对消息调用了 preventDefault()。
		 */		
		public function sendNotif(notif:Notif):Boolean
		{
			notif.setTarget(this);
			return _actor.sendNotif(notif);
		}
		/**
		 * 执行销毁 
		 */		
		ns_fancynode_mvc function doDispose():void
		{
			dispose();
		}
		/**
		 * 释放，该方法会在Context.unMapModel()的时候调用。 
		 * 
		 */		
		protected function dispose():void
		{
			
		}
	}
}