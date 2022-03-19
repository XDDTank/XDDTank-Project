// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.loader.RequestLoader

package com.pickgliss.loader
{
    import flash.net.URLVariables;

    public class RequestLoader extends TextLoader 
    {

        public function RequestLoader(_arg_1:int, _arg_2:String, _arg_3:URLVariables=null, _arg_4:String="GET")
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
        }

        override public function get type():int
        {
            return (BaseLoader.REQUEST_LOADER);
        }


    }
}//package com.pickgliss.loader

