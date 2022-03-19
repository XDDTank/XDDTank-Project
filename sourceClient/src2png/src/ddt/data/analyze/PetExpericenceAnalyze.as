// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.PetExpericenceAnalyze

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;
    import __AS3__.vec.Vector;
    import ddt.data.PetExperience;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class PetExpericenceAnalyze extends DataAnalyzer 
    {

        public var expericence:Vector.<PetExperience>;

        public function PetExpericenceAnalyze(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            var _local_3:XMLList;
            var _local_4:XML;
            var _local_5:PetExperience;
            var _local_2:XML = new XML(_arg_1);
            if (_local_2.@value == "true")
            {
                _local_3 = _local_2..Item;
                this.expericence = new Vector.<PetExperience>();
                for each (_local_4 in _local_3)
                {
                    _local_5 = new PetExperience();
                    ObjectUtils.copyPorpertiesByXML(_local_5, _local_4);
                    this.expericence.push(_local_5);
                };
                onAnalyzeComplete();
            }
            else
            {
                message = _local_2.@message;
                onAnalyzeError();
                onAnalyzeComplete();
            };
        }


    }
}//package ddt.data.analyze

