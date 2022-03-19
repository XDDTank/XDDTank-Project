// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.analyze.LoginRenameAnalyzer

package ddt.data.analyze
{
    import com.pickgliss.loader.DataAnalyzer;

    public class LoginRenameAnalyzer extends DataAnalyzer 
    {

        private var _result:XML;
        public var tempPassword:String;

        public function LoginRenameAnalyzer(_arg_1:Function)
        {
            super(_arg_1);
        }

        override public function analyze(_arg_1:*):void
        {
            this._result = new XML(_arg_1);
            onAnalyzeComplete();
        }

        public function get result():XML
        {
            return (this._result);
        }


    }
}//package ddt.data.analyze

