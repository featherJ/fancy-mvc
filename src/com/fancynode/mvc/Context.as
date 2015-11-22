package com.fancynode.mvc
{
	import com.fancynode.mvc.command.Command;
	import com.fancynode.mvc.mediator.Mediator;
	import com.fancynode.mvc.model.Model;
	import com.fancynode.mvc.notif.Notif;
	import com.fancynode.mvc.utils.ClsUtil;
	
	import flash.utils.Dictionary;
	
	import avmplus.getQualifiedClassName;

	use namespace ns_fancynode_mvc;
	/**
	 * MVC的域 
	 * @author featherJ
	 * 
	 */	
	public class Context
	{
		private var _actor:Actor;
		public function Context()
		{
			_actor = new Actor(this);
		}
		
		/**
		 * 初始化并启动
		 */		
		public function init():void
		{
			
		}
		/**
		 * 消息总线 
		 */		
		ns_fancynode_mvc function get actor():Actor
		{
			return _actor;
		}

		private var mediatorMap:Dictionary = new Dictionary();
		/**
		 * 绑定一个Mediator类型。视图层所有Mediator均为单例。在map的时候会调用其init方法。
		 * @param mediator 需要是Mediator的子类
		 */		
		public function mapMediator(mediator:Class):void
		{
			if(!ClsUtil.isChildOf(mediator,Mediator))
				throw new Error("绑定的中介者类"+getQualifiedClassName(mediator)+"需要是"+getQualifiedClassName(Mediator)+"的子类");
			for(var cls:Class in mediatorMap)
			{
				if(mediator == cls)
				{
					throw new Error("不得注册相同的Mediator:"+mediator);
				}
			}
			mediatorMap[mediator] = new mediator();
			Mediator(mediatorMap[mediator]).setActor(_actor);
			Mediator(mediatorMap[mediator]).setContext(this);
			Mediator(mediatorMap[mediator]).doInit();
		}
		/**
		 * 解绑一个Mediator类型。 
		 * @param mediator
		 * 
		 */		
		public function unMapMediator(mediator:Class):void
		{
			if(mediatorMap[mediator])
			{
				Mediator(mediatorMap[mediator]).delActor();
				Mediator(mediatorMap[mediator]).delContext();
				Mediator(mediatorMap[mediator]).doDispose();
				delete mediatorMap[mediator];
			}
		}
		
		private var modelMap:Dictionary = new Dictionary();
		/**
		 * 绑定一个Model类型。数据层所有model均为单例 。在map的时候会调用其init方法。
		 * @param model 需要是Model的子类。
		 * 
		 */		
		public function mapModel(model:Class):void
		{
			if(!ClsUtil.isChildOf(model,Model))
				throw new Error("绑定的Model类"+getQualifiedClassName(model)+"需要是"+getQualifiedClassName(Model)+"的子类");
			for(var cls:Class in modelMap)
			{
				if(model == cls)
				{
					throw new Error("不得注册相同的Model:"+model);
				}
			}
			modelMap[model] = new model();
			Model(modelMap[model]).setActor(_actor);
			Model(modelMap[model]).setContext(this);
			Model(modelMap[model]).doInit();
		}
		/**
		 * 解绑一个Model类型。 同时会调用其内部的dispose()方法
		 * @param model
		 * 
		 */		
		public function unMapModel(model:Class):void
		{
			if(modelMap[model])
			{
				Model(modelMap[model]).delActor();
				Model(modelMap[model]).delContext();
				Model(modelMap[model]).doDispose();
				delete modelMap[model];
			}
		}
		
		private var customMap:Dictionary = new Dictionary();
		
		ns_fancynode_mvc function doMapInstance(key:*,value:*):void
		{
			customMap[key] = value;
		}
		/**
		 * 绑定一个实例到所在域，该方法的目的是对指定域进行全局绑定。
		 * 但是为了保证框架的统一性，在Mediator和Model中无法进行绑定和解绑的操作，只能进行getInstance()进行获取。
		 * @param key 键
		 * @param value 值
		 * 
		 */	
		protected function mapInstance(key:*,value:*):void
		{
			doMapInstance(key,value);
		}
			
		ns_fancynode_mvc function doUnMapInstance(key:*):void
		{
			delete customMap[key];
		}
		/**
		 * 解绑一个所在域的实例，该方法的目的是对指定域的全局绑定实例进行删除。
		 * 但是为了保证框架的统一性，在Mediator和Model中无法进行绑定和解绑的操作，只能进行getInstance()进行获取。
		 * @param key 键
		 */	
		protected function unMapInstance(key:*):void
		{
			doUnMapInstance(key);
		}
			
		ns_fancynode_mvc function doGetInstance(key:*):*
		{
			return customMap[key]
		}
		/**
		 * 得到所在域已经绑定的一个实例 
		 * @param key 键
		 * @return 值
		 */	
		protected function getInstance(key:*):*
		{
			return customMap[key]
		}
		
		/**
		 * 发送一个消息 
		 * @param notif
		 * @return 如果成功调度了消息，则值为 true。值 false 表示失败或对消息调用了 preventDefault()。
		 */		
		public function sendNotif(notif:Notif):Boolean
		{
			return _actor.sendNotif(notif);
		}
		
		/**
		 * 绑定一个消息和Command的对应。 控制层所有Command均为即使创建即使销毁。
		 * @param notifType
		 * @param command 需要是Command的子类
		 * 
		 */		
		public function mapCommand(notifType:String,command:Class):void
		{
			if(!ClsUtil.isChildOf(command,Command))
				throw new Error("绑定的Command类"+getQualifiedClassName(command)+"需要是"+getQualifiedClassName(Command)+"的子类");
			_actor.mapCommand(notifType,command);
		}
		
		/**
		 * 解绑一个消息和Command的对应。 
		 * @param notifType
		 * @param command
		 * 
		 */		
		public function unMapCommand(notifType:String,command:Class):void
		{
			_actor.unMapCommand(notifType,command);
		}
		
		/**
		 * 通过类型得到一个已经绑定的model，需要提前绑定好。否则获取的时候会报错。
		 * @param type
		 * @return 
		 * 
		 */		
		ns_fancynode_mvc function getModelByType(type:String):Model
		{
			for(var cls:Class in modelMap)
			{
				if(getQualifiedClassName(cls) == type)
				{
					return modelMap[cls];
				}
			}
			throw new Error(type+"未绑定，无法得到");
		}
		
		/**
		 * 通过类型得到一个已经绑定的Mediator,如果没有绑定则过去的是null
		 * @param type
		 * @return 
		 * 
		 */		
		ns_fancynode_mvc function getMediatorByType(type:String):Mediator
		{
			for(var cls:Class in mediatorMap)
			{
				if(getQualifiedClassName(cls) == type)
				{
					return mediatorMap[cls];
				}
			}
			return null;
		}
	}
}