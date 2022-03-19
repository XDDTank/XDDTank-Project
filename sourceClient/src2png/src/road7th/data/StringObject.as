// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//road7th.data.StringObject

package road7th.data
{
    public class StringObject 
    {

        private var _data:String;

        public function StringObject(_arg_1:String="")
        {
            this._data = _arg_1;
        }

        public function get isBoolean():Boolean
        {
            var _local_1:String = this._data.toLowerCase();
            return ((this._data == "true") || (this._data == "false"));
        }

        public function get isInt():Boolean
        {
            var _local_1:RegExp = /^-?\d+$/;
            return (_local_1.test(this._data));
        }

        public function getBoolean():Boolean
        {
            if ((("true" == this._data) || ("True" == this._data)))
            {
                return (true);
            };
            if ((("false" == this._data) || ("False" == this._data)))
            {
                return (false);
            };
            if ("" == this._data)
            {
                return (false);
            };
            return (true);
        }

        public function getInt():int
        {
            return (int(this._data));
        }


    }
}//package road7th.data

