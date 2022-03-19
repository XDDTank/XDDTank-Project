// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.ToolPropInfo

package ddt.view.tips
{
    import ddt.data.goods.ItemTemplateInfo;

    public class ToolPropInfo 
    {

        public static const Psychic:String = "Psychic";
        public static const Energy:String = "Energy";
        public static const MP:String = "mp";

        public var showTurn:Boolean;
        public var showCount:Boolean;
        public var showThew:Boolean;
        public var info:ItemTemplateInfo;
        public var count:int;
        public var valueType:String = "Energy";
        public var value:int;
        public var shortcutKey:String;
        public var isMax:Boolean = true;


    }
}//package ddt.view.tips

