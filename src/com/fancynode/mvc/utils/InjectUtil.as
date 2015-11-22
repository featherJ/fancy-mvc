package com.fancynode.mvc.utils
{
	import com.fancynode.mvc.Context;
	import com.fancynode.mvc.ns_fancynode_mvc;
	import com.fancynode.mvc.command.Command;
	import com.fancynode.mvc.mediator.Mediator;
	import com.fancynode.mvc.model.Model;
	
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	use namespace ns_fancynode_mvc
	[ExcludeClass]
	/**
	 * 注入工具 
	 * @author featherJ
	 * 
	 */	
	public class InjectUtil
	{
		/**
		 * 为command注入Model,需要提前在context里绑定好。
		 */		
		ns_fancynode_mvc static function injectModel(command:Command,context:Context):void
		{
			var info:XML = describeType(command);
			var variables:Object = {};
			for each(var node:XML in info.variable)
			{
				var vName:String = node.@name.toString();
				var vType:String = node.@type.toString();
				variables[vName] = vType;
			}
			for(var name:String in variables)
			{
				var type:String = variables[name];
				if(ClsUtil.isChildOf(getDefinitionByName(type) as Class,Model))
				{
					command[name] = context.getModelByType(type);
				}
			}
		}
		
		/**
		 * 为command注入Mediator，因为可以即使绑定即使注入，如果在还没注入的时候进行绑定则注入的是空。
		 */		
		ns_fancynode_mvc static function injectMediator(command:Command,context:Context):void
		{
			var info:XML = describeType(command);
			var variables:Object = {};
			for each(var node:XML in info.variable)
			{
				var vName:String = node.@name.toString();
				var vType:String = node.@type.toString();
				variables[vName] = vType;
			}
			
			for(var name:String in variables)
			{
				var type:String = variables[name];
				if(ClsUtil.isChildOf(getDefinitionByName(type) as Class,Mediator))
				{
					var mediator:Mediator = context.getMediatorByType(type) as Mediator;
					if(mediator)
						command[name] = mediator;
				}
			}
		}
		
		/**
		 * 清空所有的注入，同时也会清空所有的public类型属性，以便于之后的自动释放 
		 * @param command
		 * 
		 */		
		ns_fancynode_mvc static function clearProperty(command:Command):void
		{
			var info:XML = describeType(command);
			for each(var node:XML in info.variable)
			{
				var vName:String = node.@name.toString();
				command[vName] = null;
			}
		}
	}
}