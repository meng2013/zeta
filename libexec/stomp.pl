#!/usr/bin/perl
use Zeta::Run;
use POE;
use POE::Component::Logger;
use POE::Component::MessageQueue;
use POE::Component::MessageQueue::Storage::Default;
use POE::Component::MessageQueue::Logger;
use Carp;
use strict;

sub {

    my $zcfg = zkernel->zconfig;

    $SIG{__DIE__} = sub {
        Carp::confess(@_);
    };
    
    # Force some logger output without using the real logger.
    $POE::Component::MessageQueue::Logger::LEVEL = 0;
   
    # default storage 
    my $data_dir = "/tmp";
    my $port     = $zcfg->{stomp}{port},
    my $hostname = $zcfg->{stomp}{host},
    my $timeout  = 4;
    my $throttle_max = 2;
    my $dft_args = {
 		data_dir     => $data_dir,
   		timeout      => $timeout,
   		throttle_max => $throttle_max
    };
    POE::Component::MessageQueue->new({
    	port     => $port,
    	hostname => $hostname,
    	storage   => POE::Component::MessageQueue::Storage::Default->new($dft_args),
    });
    
    $poe_kernel->run();
    exit;
};


