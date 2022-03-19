// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.BeadModel

package ddt.data
{
    import flash.utils.Dictionary;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.goods.ItemTemplateInfo;

    public class BeadModel 
    {

        private static var _ins:BeadModel;

        private var _beadDic:Dictionary = new Dictionary();


        public static function getInstance():BeadModel
        {
            if (_ins == null)
            {
                _ins = ComponentFactory.Instance.creatCustomObject("BeadModel");
            };
            return (_ins);
        }


        public function set beads(_arg_1:String):void
        {
            var _local_3:int;
            var _local_2:Array = _arg_1.split(",");
            for each (_local_3 in _local_2)
            {
                this._beadDic[String(_local_3)] = true;
            };
        }

        public function isBeadFromSmelt(_arg_1:int):Boolean
        {
            return (this._beadDic[String(_arg_1)] == true);
        }

        public function isAttackBead(_arg_1:ItemTemplateInfo):Boolean
        {
            return ((this.isBeadFromSmelt(_arg_1.TemplateID)) && (_arg_1.Property2 == "1"));
        }

        public function isDefenceBead(_arg_1:ItemTemplateInfo):Boolean
        {
            return ((this.isBeadFromSmelt(_arg_1.TemplateID)) && (_arg_1.Property2 == "2"));
        }

        public function isAttributeBead(_arg_1:ItemTemplateInfo):Boolean
        {
            return ((this.isBeadFromSmelt(_arg_1.TemplateID)) && (_arg_1.Property2 == "3"));
        }


    }
}//package ddt.data

