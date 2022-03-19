// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.loader.CompressRequestLoader

package com.pickgliss.loader
{
    import flash.net.URLVariables;

    public class CompressRequestLoader extends CompressTextLoader 
    {

        public function CompressRequestLoader(_arg_1:int, _arg_2:String, _arg_3:URLVariables=null, _arg_4:String="GET")
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4);
        }

        override public function get type():int
        {
            return (BaseLoader.COMPRESS_REQUEST_LOADER);
        }


    }
}//package com.pickgliss.loader

