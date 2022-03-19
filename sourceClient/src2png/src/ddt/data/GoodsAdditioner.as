// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.GoodsAdditioner

package ddt.data
{
    import ddt.data.analyze.GoodsAdditionAnalyer;
    import flash.geom.Point;

    public class GoodsAdditioner 
    {

        private static var _instance:GoodsAdditioner;

        private var _additionArr:Array;


        public static function get Instance():GoodsAdditioner
        {
            if (_instance == null)
            {
                _instance = new (GoodsAdditioner)();
            };
            return (_instance);
        }


        public function addGoodsAddition(_arg_1:GoodsAdditionAnalyer):void
        {
            this._additionArr = _arg_1.additionArr;
        }

        public function getpropertySuccessRate(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):Point
        {
            if (_arg_1 != 17)
            {
                _arg_2 = 0;
            };
            _arg_3 = (_arg_3 + 1);
            if (this._additionArr == null)
            {
                return (null);
            };
            var _local_5:Point = new Point();
            var _local_6:Array = new Array();
            var _local_7:Array = new Array();
            _local_6 = this._additionArr;
            var _local_8:int;
            while (_local_8 < _local_6.length)
            {
                if (_local_6[_local_8].ItemCatalog == _arg_1)
                {
                    _local_7.push(_local_6[_local_8]);
                };
                _local_8++;
            };
            _local_6 = _local_7;
            _local_7 = new Array();
            _local_8 = 0;
            while (_local_8 < _local_6.length)
            {
                if (_local_6[_local_8].SubCatalog == _arg_2)
                {
                    _local_7.push(_local_6[_local_8]);
                };
                _local_8++;
            };
            _local_6 = _local_7;
            _local_7 = new Array();
            _local_8 = 0;
            while (_local_8 < _local_6.length)
            {
                if (_local_6[_local_8].StrengthenLevel == _arg_3)
                {
                    _local_7.push(_local_6[_local_8]);
                };
                _local_8++;
            };
            _local_6 = _local_7;
            _local_7 = new Array();
            _local_8 = 0;
            while (_local_8 < _local_6.length)
            {
                if (_local_6[_local_8].FailtureTimes == _arg_4)
                {
                    _local_5.x = _local_6[_local_8].PropertyPlus;
                    _local_5.y = _local_6[_local_8].SuccessRatePlus;
                };
                _local_8++;
            };
            return (_local_5);
        }


    }
}//package ddt.data

