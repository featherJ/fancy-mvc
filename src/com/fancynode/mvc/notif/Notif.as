package com.fancynode.mvc.notif
{
	import com.fancynode.mvc.ns_fancynode_mvc;

	/**
	 * 消息 
	 * @author featherJ
	 *
	 */	
	public class Notif
	{
		private var _type:String;
		/**
		 * 消息类型 
		 */		
		public function get type():String
		{
			return _type;
		}
		
		private var _target:Object;
		/**
		 * 消息的发送者
		 * @return 
		 */		
		public function get target():Object
		{
			return _target;
		}
		/**
		 * 消息 
		 * @param type 消息类型
		 * 
		 */		
		public function Notif(type:String)
		{
			_type = type;
		}
		/**
		 * 设置消息发送者 
		 * @param $target
		 */		
		ns_fancynode_mvc function setTarget($target:Object):void
		{
			_target = $target;
		}
		
		private var _isPreventDefault:Boolean = false;
		/**
		 * 取消该消息的默认行为。  
		 */		
		public function preventDefault():void
		{
			_isPreventDefault = true;
		}
		
		/**
		 * 检查是否已对消息调用 preventDefault() 方法。如果已调用 preventDefault() 方法，则返回 true；否则返回 false。 
		 */		
		public function isDefaultPrevented():Boolean
		{
			return _isPreventDefault;
		}
		
	}
}