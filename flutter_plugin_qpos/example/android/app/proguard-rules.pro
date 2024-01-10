#####################################################################################
# start on 2017/5/16 15:59
# update author: qihao on 2017/7/4 17:53  http://blog.csdn.net/gfg156196
# Email：sin2t@sina.com
#
#####################################################################################
    #指定代码的压缩级别
    -optimizationpasses 5
    #包名不混合大小写
    -dontusemixedcaseclassnames
    #不去忽略非公共的库类
    -dontskipnonpubliclibraryclasses
     #优化  不优化输入的类文件
    -dontoptimize
     #混淆时是否做预校验
    -dontpreverify
     #混淆时是否记录日志
    -verbose
     # 混淆时所采用的算法
    -optimizations !code/simplification/arithmetic,!field/*,!class/merging/*
    #保护注解
    -keepattributes *Annotation*
     #如果引用了v4或者v7包
    -dontwarn android.support.**
    #-dontwarn android.*.*
    #忽略警告
    -ignorewarnings
    #保证是独立的jar
    -dontshrink

    -keep class org.bouncycastle.**{*;}
    -dontwarn org.bouncycastle.**

    -keep class Decoder.**{*;}
    -dontwarn Decoder.**

    -keep class com.xcheng.**{*;}
    -dontwarn com.xcheng.**

    -dontskipnonpubliclibraryclassmembers
    -useuniqueclassmembernames
    -keeppackagenames
    -keepattributes Exceptions,InnerClasses,Signature,Deprecated,SourceFile,LineNumberTable,LocalVariable*Table,Synthetic,EnclosingMethod
    -keepparameternames
    -dontnote



    #保持 native 方法不被混淆
    -keepclasseswithmembernames class * {
        native <methods>;
    }

    -keepnames class * implements java.io.Serializable

    #保持 Serializable 不被混淆并且enum 类也不被混淆
    -keepclassmembers class * implements java.io.Serializable {
        static final long serialVersionUID;
        private static final java.io.ObjectStreamField[] serialPersistentFields;
        !static !transient <fields>;
        !private <fields>;
        !private <methods>;
        private void writeObject(java.io.ObjectOutputStream);
        private void readObject(java.io.ObjectInputStream);
        java.lang.Object writeReplace();
        java.lang.Object readResolve();
    }

    #避免混淆泛型 如果混淆报错建议关掉
    #–keepattributes Signature

    #关闭所有日志 log, java.io.Print, printStackTrace
#    -assumenosideeffects class android.util.Log {
#        public static *** e(...);
#        public static *** w(...);
#        public static *** i(...);
#        public static *** d(...);
#        public static *** v(...);
#    }
    -assumenosideeffects class java.io.PrintStream {
        public *** print(...);
        public *** println(...);
    }
    -assumenosideeffects class java.lang.Throwable {
        public *** printStackTrace(...);
    }

    -keep class com.dspread.august.common.wbaes** {
        *;
    }

     -keep class com.xcheng.ledmanager** {
        *;
    }

    -keep class * implements com.dspread.august.common.wbaes.Copyable { *; }

    #下面的类将不会被混淆，这样的类是需要被jar包使用者直接调用的
    -keep,allowshrinking public  class android_serialport_api.SerialPort{
        public *;
    }

    -keep,allowshrinking public  class android_serialport_api.SerialPortFinder{
            public *;
    }
    -keep,allowshrinking public  class android_serialport_sdk.DspSerialPort{
        public *;
    }

    -keep,allowshrinking public  class android_serialport_sdk.DspSerialPortFinder{
            public *;
    }

    -keep,allowshrinking public  class com.dspread.xpos.QPOSService{
        public *;
    }

    -keep,allowshrinking public  class com.xcheng.ledmanager.LedManager{
        public *;
    }
    -keep,allowshrinking public  class com.dspread.xpos.CQPOSService{
            public *;
    }

    -keep,allowshrinking public  class com.dspread.xpos.DspFingerPrint{
        public *;
    }

     -keep,allowshrinking public  class com.dspread.xpos.A01Kernel{
        public *;
    }

    -keep,allowshrinking public  class com.dspread.xpos.HdxUtil{
        public *;
    }

    -keep,allowshrinking public  class com.dspread.xpos.EmvCapkTag{
        public *;
    }

    -keep,allowshrinking public  class com.dspread.xpos.EmvAppTag{
        public *;
    }

    -keep,allowshrinking public  class com.dspread.xpos.Tlv{
        public *;
    }

     -keep,allowshrinking public  class com.dspread.xpos.TradeSoundType{
            public *;
        }

     -keep,allowshrinking public  class com.dspread.xpos.Util{
                public *;
            }

    -keep,allowshrinking public  class com.dspread.xpos.SyncUtil{
        public *;
    }

    -keep,allowshrinking public  class com.dspread.xpos.utils.AESUtil{
          public *;
    }
    -keep,allowshrinking public  class com.dspread.xpos.utils.BASE64Decoder{
           public *;
    }
    -keep,allowshrinking public  class com.dspread.xpos.utils.BASE64Encoder{
           public *;
    }
    -keep,allowshrinking public  class com.dspread.xpos.utils.CEFormatException{
           public *;
     }
    -keep,allowshrinking public  class com.dspread.xpos.utils.CEStreamExhausted{
           public *;
     }
     -keep,allowshrinking public  class com.dspread.xpos.utils.CharacterDecoder{
           public *;
     }
     -keep,allowshrinking public  class com.dspread.xpos.utils.CharacterEncoder{
           public *;
     }

     -keep,allowshrinking public class com.dspread.xpos.QPOSService,com.dspread.xpos.QPOSService$* {
         public <methods>;
         public <fields>;
     }
     -keep,allowshrinking public class com.dspread.xpos.DspFingerPrint,com.dspread.xpos.DspFingerPrint$* {
         public <methods>;
         public <fields>;
     }

    #-keep,allowshrinking public  enum com.dspread.xpos.**{*;}
    #-keep,allowshrinking public  interface com.dspread.xpos.**{*;}
    #-keep,allowshrinking public  abstract com.dspread.xpos.**{*;}


    #保持枚举 enum 类不被混淆 如果混淆报错，建议直接使用上面的 -keepclassmembers class * implements java.io.Serializable即可
    # Also keep - Enumerations. Keep the special static methods that are required in
    # enumeration classes.
    -keepclassmembers enum  * {
        public static **[] values();
        public static ** valueOf(java.lang.String);
    }

-keep class src.main.jniLibs.** { *; }
-keep class io.flutter.plugin.** { *; }


#-libraryjars 'D:\DspreadSDKCode\Flutter\tradeDemo\flutter_plugin_qpos\android\libs\dspread_pos_sdk_4.5.3.jar'