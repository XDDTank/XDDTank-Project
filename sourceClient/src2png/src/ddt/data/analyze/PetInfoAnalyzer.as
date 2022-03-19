// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.PetInfoAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import flash.utils.Dictionary;
    import pet.date.PetTemplateInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class PetInfoAnalyzer extends DataAnalyzer 
    {

        public var list:Dictionary = new Dictionary();

        public function PetInfoAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_4:XML;
            var _local_5:PetTemplateInfo;
            var _local_2:XML = XML(_arg_1);
            var _local_3:XMLList = _local_2..Item;
            for each (_local_4 in _local_3)
            {
                _local_5 = new PetTemplateInfo();
                ObjectUtils.copyPorpertiesByXML(_local_5, _local_4);
                this.list[_local_5.TemplateID] = _local_5;
            };
            onAnalyzeComplete();
        }


    }
}//package ddt.data.analyze

