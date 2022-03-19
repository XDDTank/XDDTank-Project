// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.PetEggInfoAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import flash.utils.Dictionary;
    import pet.date.PetEggInfo;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class PetEggInfoAnalyzer extends DataAnalyzer 
    {

        public var list:Dictionary = new Dictionary();

        public function PetEggInfoAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_4:XML;
            var _local_5:PetEggInfo;
            var _local_2:XML = XML(_arg_1);
            var _local_3:XMLList = _local_2..Item;
            for each (_local_4 in _local_3)
            {
                _local_5 = new PetEggInfo();
                ObjectUtils.copyPorpertiesByXML(_local_5, _local_4);
                if ((!(this.list[_local_5.Kind])))
                {
                    this.list[_local_5.Kind] = new Vector.<PetEggInfo>();
                };
                this.list[_local_5.Kind].push(_local_5);
            };
            onAnalyzeComplete();
        }


    }
}//package ddt.data.analyze

