package com.fancynode.mvc.utils
{
	import flash.utils.getDefinitionByName;
	
	import avmplus.getQualifiedClassName;
	import avmplus.getQualifiedSuperclassName;
	import com.fancynode.mvc.ns_fancynode_mvc;

	use namespace ns_fancynode_mvc;
	[ExcludeClass]
	/**
	 * 类工具 
	 * @author featherJ
	 * 
	 */	
	public class ClsUtil
	{
		/**
		 * 检查A类是B类的子类,当两个类相同时也返回false
		 * @param A
		 * @param B
		 * @return 
		 * 
		 */		
		ns_fancynode_mvc static function isChildOf(A:Class,B:Class):Boolean
		{
			var current:Object = A;
			if(getQualifiedClassName(current) == getQualifiedClassName(B))
				return false;
			while(true)
			{
				if(getQualifiedClassName(current) == getQualifiedClassName(B))
				{
					return true;
				}else
				{
					var superQualified:String = getQualifiedSuperclassName(current);
					try
					{
						current = getDefinitionByName(superQualified);
					} 
					catch(error:Error) 
					{
						return false;
					}
				}
			}
			return false;
		}
	}
}