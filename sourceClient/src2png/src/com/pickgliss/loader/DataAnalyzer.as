// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.loader.DataAnalyzer

package com.pickgliss.loader
{
    public class DataAnalyzer 
    {

        protected var _onCompleteCall:Function;
        public var message:String;
        public var analyzeCompleteCall:Function;
        public var analyzeErrorCall:Function;

        public function DataAnalyzer(_arg_1:Function)
        {
            this._onCompleteCall = _arg_1;
        }

        public function analyze(_arg_1:*):void
        {
        }

        protected function onAnalyzeComplete():void
        {
            if (this._onCompleteCall != null)
            {
                this._onCompleteCall(this);
            };
            if (this.analyzeCompleteCall != null)
            {
                this.analyzeCompleteCall();
            };
            this._onCompleteCall = null;
            this.analyzeCompleteCall = null;
        }

        protected function onAnalyzeError():void
        {
            if (this.analyzeErrorCall != null)
            {
                this.analyzeErrorCall();
            };
        }


    }
}//package com.pickgliss.loader

