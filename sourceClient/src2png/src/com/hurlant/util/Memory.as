﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.hurlant.util.Memory

package com.hurlant.util
{
    import flash.net.LocalConnection;
    import flash.system.System;

    public class Memory 
    {


        public static function gc():void
        {
            try
            {
                new LocalConnection().connect("foo");
                new LocalConnection().connect("foo");
            }
            catch(e)
            {
            };
        }

        public static function get used():uint
        {
            return (System.totalMemory);
        }


    }
}//package com.hurlant.util

